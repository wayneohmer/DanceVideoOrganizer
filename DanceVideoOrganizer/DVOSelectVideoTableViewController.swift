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

    var allVideos = PHFetchResult()
    var videoAssets = [DVOVideoAsset]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchPhotos()
        self.tableView.reloadData()
    }

    func fetchPhotos() {
        
        let fetchRequest = NSFetchRequest()
        
        let assetEntity = NSEntityDescription.entityForName(VideoAssets.entityName, inManagedObjectContext: DVOCoreData.sharedObject.managedObjectContext)
        fetchRequest.entity = assetEntity
        
        fetchRequest.fetchBatchSize = 0
        
        let sortDescriptor = NSSortDescriptor(key: VideoAssetsAttributes.createdDate, ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = NSPredicate(format:"metaData = nil")
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DVOCoreData.sharedObject.managedObjectContext, sectionNameKeyPath: nil, cacheName: "Master")
        
        do {
            try fetchedResultsController.performFetch()
            if let assets = fetchedResultsController.fetchedObjects as? [VideoAssets]{
                for asset in assets {
                    let newAsset = DVOVideoAsset()
                    newAsset.address = asset.address ?? ""
                    newAsset.locationKey = asset.locationKey ?? ""
                    newAsset.creationDate = asset.createdDate ?? NSDate()
                    newAsset.assetLocalIdentifier = asset.localIdentifier ?? ""
                    if let foundLocations = asset.valueForKey("studio") as? [Studio] {
                        for location in foundLocations {
                            if let locationName = location.valueForKey("name") as? String {
                                newAsset.locationName = locationName
                            }
                        }
                    }
                    if newAsset.locationName == "" {
                        if let foundLocations = asset.valueForKey("event") as? [Event] {
                            for location in foundLocations {
                                if let locationName = location.valueForKey("name") as? String {
                                    newAsset.locationName = locationName
                                }
                            }
                        }
                        if newAsset.locationName == "" {
                            if let foundLocations = asset.valueForKey("possibleEvent") as? [Event] {
                                for location in foundLocations {
                                    if let locationName = location.valueForKey("name") as? String {
                                        newAsset.locationName = "\(locationName) ??"
                                    }
                                }
                            }
                        }
                    }
                    if let localIdentifier = asset.valueForKey("localIdentifier") as? String {
                        let allVideosOptions = PHFetchOptions()
                        allVideosOptions.predicate = NSPredicate(format: "localIdentifier = \"\(localIdentifier)\"")
                        allVideosOptions.includeAssetSourceTypes =  [PHAssetSourceType.TypeCloudShared,PHAssetSourceType.TypeUserLibrary,PHAssetSourceType.TypeiTunesSynced]
                        let getVideos = PHAsset.fetchAssetsWithOptions(allVideosOptions)
                        getVideos.enumerateObjectsUsingBlock() { (asset, index, done) in
                            let imageManager = PHImageManager()
                            
                            imageManager.requestImageForAsset(asset as! PHAsset, targetSize: CGSize(width: 500, height: 500) , contentMode: .AspectFill, options: nil) { (result, info) in
                                if let thisResult = result {
                                    newAsset.thumbNail = thisResult
                                }
                            }
                            let options = PHVideoRequestOptions()
                            options.networkAccessAllowed = true
                            imageManager.requestAVAssetForVideo(asset as! PHAsset, options: options ) { (videoAsset, mix, info) in
                                newAsset.videoAsset = videoAsset
                            }
                        }
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

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.videoAssets.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("VideoCell") as! VideoCell
        let asset = self.videoAssets[indexPath.item]
        if asset.locationName != "" {
            cell.locationLabel.text = asset.locationName
        } else {
            cell.locationLabel.text = asset.address
        }
        cell.locationKeyLabel.text = asset.locationKey
        cell.dateLabel.text = DVODateFormatter.formattedDate(asset.creationDate)
        cell.videoThumbNailImage.image = asset.thumbNail
        cell.videoThumbNailImage.contentMode = .ScaleAspectFit
        cell.layoutIfNeeded()
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let controller = segue.destinationViewController as! DVOEditVideoDataViewController
            controller.videoAsset = self.videoAssets[indexPath.item]
        }
    }

}

class VideoCell: UITableViewCell {
    
    @IBOutlet weak var videoThumbNailImage: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationKeyLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
}
