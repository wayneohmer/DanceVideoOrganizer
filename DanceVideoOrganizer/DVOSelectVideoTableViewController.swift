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
    var videoAssets = [VideoAsset]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchPhonos()
        self.tableView.reloadData()
    }

    func fetchPhonos() {
        let fetchRequest = NSFetchRequest()
        
        let locationEntity = NSEntityDescription.entityForName("VideoAssets", inManagedObjectContext: DVOCoreData.sharedObject.managedObjectContext)
        fetchRequest.entity = locationEntity
        
        fetchRequest.fetchBatchSize = 0
        
        let sortDescriptor = NSSortDescriptor(key: "createdDate", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DVOCoreData.sharedObject.managedObjectContext, sectionNameKeyPath: nil, cacheName: "Master")
        
        do {
            try fetchedResultsController.performFetch()
            for asset in fetchedResultsController.fetchedObjects! {
                let newVideo = VideoAsset()
                if let creationDate = asset.valueForKey("createdDate") as? NSDate {
                    newVideo.creationDate = creationDate
                }
                if let locationKey = asset.valueForKey("locationKey") as? String {
                    if let address = DVOCoreData.foundAddresses[locationKey] {
                        newVideo.address = address
                        newVideo.locationKey = locationKey
                    }
                    if let foundLocations = asset.valueForKey("studio") as? [AnyObject] {
                        for location in foundLocations {
                            if let locationName = location.valueForKey("name") as? String {
                                newVideo.locationName = locationName
                            }
                        }
                    }
                }
                if let localIdentifier = asset.valueForKey("localIdentifier") as? String {
                    let allVideosOptions = PHFetchOptions()
                    allVideosOptions.predicate = NSPredicate(format: "localIdentifier = \"\(localIdentifier)\"")
                    let getVideos = PHAsset.fetchAssetsWithOptions(allVideosOptions)
                    getVideos.enumerateObjectsUsingBlock() { (asset, index, done) in
                        let imageManager = PHCachingImageManager()
                        imageManager.requestImageForAsset(asset as! PHAsset, targetSize: CGSize(width: 500, height: 500) , contentMode: .AspectFill, options: nil) { (result, info) in
                            if let thisResult = result {
                                newVideo.thumbNail = thisResult
                            }
                        }
                        imageManager.requestAVAssetForVideo(asset as! PHAsset, options: nil ) { (videoAsset, mix, info) in
                            newVideo.videoAsset = videoAsset
                        }
                    }
                }
                self.videoAssets.append(newVideo)
            }
        } catch {
            print("Counld not fetch photots")
        }
        print(self.videoAssets.count)
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
        cell.dateLabel.text = "\(asset.creationDate)"
        cell.videoThumbNailImage.image = asset.thumbNail
        cell.videoThumbNailImage.contentMode = .ScaleAspectFit
        cell.layoutIfNeeded()
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let controller = segue.destinationViewController as! AVPlayerViewController
            controller.player =  AVPlayer(playerItem: AVPlayerItem(asset: self.videoAssets[indexPath.item].videoAsset!))
            controller.player?.currentItem?.seekToTime(CMTimeMakeWithSeconds(15,1))
            controller.player?.play()
        }
    }

}

class VideoCell: UITableViewCell {
    
    @IBOutlet weak var videoThumbNailImage: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
}
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

