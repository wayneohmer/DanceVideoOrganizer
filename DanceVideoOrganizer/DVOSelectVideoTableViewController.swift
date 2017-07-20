//
//  DVOSelectVideoTableViewController.swift
//  DanceVideoOrganizer
//
//  Created by Wayne Ohmer on 5/26/16.
//  Copyright © 2016 Wayne Ohmer. All rights reserved.
//

import UIKit
import CoreData
import Photos
import AVKit

class DVOSelectVideoTableViewController: UITableViewController {

    var allVideos:PHFetchResult<VideoAssets> = PHFetchResult()
    var videoAssets = [DVOVideoAsset]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchPhotos()
        self.tableView.reloadData()
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)

    }

    func fetchPhotos() {
        
        let fetchRequest:NSFetchRequest<VideoAssets> = NSFetchRequest()
        
        let assetEntity = NSEntityDescription.entity(forEntityName: VideoAssets.entityName, in: DVOCoreData.sharedObject.managedObjectContext)
        fetchRequest.entity = assetEntity
        
        fetchRequest.fetchBatchSize = 0
        
        let sortDescriptor = NSSortDescriptor(key: VideoAssetsAttributes.createdDate, ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = NSPredicate(format:"metaData = nil")
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DVOCoreData.sharedObject.managedObjectContext, sectionNameKeyPath: nil, cacheName: "Master")
        
        do {
            try fetchedResultsController.performFetch()
            if let assets = fetchedResultsController.fetchedObjects as [VideoAssets]? {
                for asset in assets {
                    let newAsset = DVOVideoAsset()
                    newAsset.address = asset.address ?? ""
                    newAsset.locationKey = asset.locationKey ?? ""
                    newAsset.creationDate = asset.createdDate ?? Date()
                    newAsset.assetLocalIdentifier = asset.localIdentifier ?? ""
                    if let foundLocations = asset.value(forKey: "studio") as? [Studio] {
                        for location in foundLocations {
                            if let locationName = location.value(forKey: "name") as? String {
                                newAsset.locationName = locationName
                            }
                        }
                    }
                    if newAsset.locationName == "" {
                        if let foundLocations = asset.value(forKey: "event") as? [Event] {
                            for location in foundLocations {
                                if let locationName = location.value(forKey: "name") as? String {
                                    newAsset.locationName = locationName
                                }
                            }
                        }
                        if newAsset.locationName == "" {
                            if let foundLocations = asset.value(forKey: "possibleEvent") as? [Event] {
                                for location in foundLocations {
                                    if let locationName = location.value(forKey: "name") as? String {
                                        newAsset.locationName = "\(locationName) ??"
                                    }
                                }
                            }
                        }
                    }
                    if let localIdentifier = asset.value(forKey: "localIdentifier") as? String {
                        let allVideosOptions = PHFetchOptions()
                        allVideosOptions.predicate = NSPredicate(format: "localIdentifier = \"\(localIdentifier)\"")
                        allVideosOptions.includeAssetSourceTypes =  [PHAssetSourceType.typeCloudShared,PHAssetSourceType.typeUserLibrary,PHAssetSourceType.typeiTunesSynced]
                        let getVideos:PHFetchResult<PHAsset> = PHAsset.fetchAssets(with: allVideosOptions)
                        getVideos.enumerateObjects({ (asset, index, done) in
                            let imageManager = PHImageManager()
                            
                            imageManager.requestImage(for: asset, targetSize: CGSize(width: 500, height: 500) , contentMode: .aspectFill, options: nil) { (result, info) in
                                if let thisResult = result {
                                    newAsset.thumbNail = thisResult
                                }
                            }
                            let options = PHVideoRequestOptions()
                            options.isNetworkAccessAllowed = true
                            imageManager.requestAVAsset(forVideo: asset, options: options ) { (videoAsset, mix, info) in
                                newAsset.videoAsset = videoAsset
                            }
                        })
                    }
                    self.videoAssets.append(newAsset)
                }
            }
        } catch {
            print("Counld not fetch photots")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.videoAssets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell") as! VideoCell
        let asset = self.videoAssets[(indexPath as NSIndexPath).item]
        if asset.locationName != "" {
            cell.locationLabel.text = asset.locationName
        } else {
            cell.locationLabel.text = asset.address
        }
        cell.locationKeyLabel.text = asset.locationKey
        cell.dateLabel.text = DVODateFormatter.formattedDate(asset.creationDate)
        cell.videoThumbNailImage.image = asset.thumbNail
        //cell.videoThumbNailImage.contentMode = .scaleAspectFit
        cell.layoutIfNeeded()
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let controller = segue.destination as! DVOEditVideoDataViewController
            controller.videoAsset = self.videoAssets[(indexPath as NSIndexPath).item]
        }
    }

}

class VideoCell: UITableViewCell {
    
    @IBOutlet weak var videoThumbNailImage: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationKeyLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
}
