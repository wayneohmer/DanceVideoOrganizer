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

class DVOEditVideoDataViewController: UIViewController {

    var videoAsset = VideoAsset()
    
    @IBOutlet weak var thumbNailImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.thumbNailImageView.image = self.videoAsset.thumbNail
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let controller = segue.destinationViewController as! AVPlayerViewController
        controller.player =  AVPlayer(playerItem: AVPlayerItem(asset: self.videoAsset.videoAsset!))
        controller.player?.play()
    }
    
}
