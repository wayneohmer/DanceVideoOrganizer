//
//  DVOMetaDataTableViewController.swift
//  DanceVideoOrganizer
//
//  Created by Wayne Ohmer on 6/16/16.
//  Copyright © 2016 Wayne Ohmer. All rights reserved.
//

import UIKit
import Photos
import AVKit

class DVOMetaDataTableViewController: UITableViewController {

    var metaData = [VideoMetaData]()
    
    override func viewDidLoad() {
        let fetchedResultsController = DVOCoreData.fetchMetaData()
        do {
            try fetchedResultsController.performFetch()
            if let metaData = fetchedResultsController.fetchedObjects as [VideoMetaData]? {
                self.metaData = metaData
                for metaDatum in metaData {
                    if let localIdentifier = metaDatum.asset?.value(forKey: "localIdentifier") as? String {
                        let allVideosOptions = PHFetchOptions()
                        allVideosOptions.predicate = NSPredicate(format: "localIdentifier = \"\(localIdentifier)\"")
                        allVideosOptions.includeAssetSourceTypes =  [PHAssetSourceType.typeCloudShared,PHAssetSourceType.typeUserLibrary,PHAssetSourceType.typeiTunesSynced]
                        let getVideos = PHAsset.fetchAssets(with: allVideosOptions)
                        getVideos.enumerateObjects({ (asset, index, done) in
                            let imageManager = PHImageManager()
                            
                            imageManager.requestImage(for: asset, targetSize: CGSize(width: 500, height: 500) , contentMode: .aspectFill, options: nil) { (result, info) in
                                if let thisResult = result {
                                    metaDatum.thumbnail = thisResult
                                }
                            }
                            let options = PHVideoRequestOptions()
                            options.isNetworkAccessAllowed = true
                            imageManager.requestAVAsset(forVideo: asset, options: options ) { (videoAsset, mix, info) in
                                metaDatum.avAsset = videoAsset
                            }
                        })
                    }
                }
                self.tableView.reloadData()
            }
        } catch {
            
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.metaData.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DVOMetaDataCell") as! DVOMetaDataCell
        let thisMetaData = self.metaData[(indexPath as NSIndexPath).item]
        cell.thumbNailImagView.image = thisMetaData.thumbnail
        cell.locationLabel.text = thisMetaData.location
        cell.dancersLabel.text = thisMetaData.dancers
        
        cell.dateLabel.text = DVODateFormatter.formattedDate(thisMetaData.date)
        
        return cell
    }

}
