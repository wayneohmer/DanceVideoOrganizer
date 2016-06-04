//
//  DVOEditVideoDataViewController.swift
//  DanceVideoOrganizer
//
//  Created by Wayne Ohmer on 5/31/16.
//  Copyright © 2016 Wayne Ohmer. All rights reserved.
//

import UIKit
import AVKit
import Photos

class DVOEditVideoDataViewController: UIViewController, UITabBarDelegate, UITableViewDelegate {

    var videoAsset = DVOVideoAsset()
    var cellArray:[DVOMetaDataEntryLayout.CellData]!
    var layout:DVOMetaDataEntryLayout!
    @IBOutlet weak var layoutTableView: UITableView!
    @IBOutlet weak var thumbNailImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.thumbNailImageView.image = self.videoAsset.thumbNail
        self.layout = DVOMetaDataEntryLayout(videoAsset: self.videoAsset)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.cellArray = self.layout.updateCells()
        self.layoutTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let controller = segue.destinationViewController as! AVPlayerViewController
        controller.player =  AVPlayer(playerItem: AVPlayerItem(asset: self.videoAsset.videoAsset!))
        controller.player?.play()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DVOMetaDataEntryCell", forIndexPath: indexPath) as! DVOMetaDataEntryCell
        cell.descriptionLabel.text = self.cellArray[indexPath.item].description
        cell.dataLabel.text = self.cellArray[indexPath.item].data
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.cellArray[indexPath.item].destination?(navController: self.navigationController)
    }

}
