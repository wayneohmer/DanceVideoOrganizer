//
//  DVOVideoPlayerViewController.swift
//  DanceVideoOrganizer
//
//  Created by Wayne Ohmer on 6/6/16.
//  Copyright © 2016 Wayne Ohmer. All rights reserved.
//

import UIKit
import AVKit
import Photos

class DVOVideoPlayerViewController: UIViewController {

    var videoAsset: AVAsset!
    var savedTimes = [CMTime(seconds: 0.0, preferredTimescale: 1)]
    @IBOutlet weak var videoPlayerView: UIView!
    @IBOutlet weak var momentButton: UIButton!
    @IBOutlet weak var momentLabel: UILabel!
    
    let playerController = AVPlayerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.translucent = false
        self.playerController.player = AVPlayer(playerItem: AVPlayerItem(asset: videoAsset))
        playerController.view.frame = CGRectMake(0, 0, self.videoPlayerView.frame.width, self.videoPlayerView.frame.height)
        self.videoPlayerView.addSubview(playerController.view)
        
        self.videoPlayerView.layer.borderWidth = 3
        self.videoPlayerView.layer.borderColor = UIColor.blackColor().CGColor
        self.videoPlayerView.layoutIfNeeded()
        //controller.player?.play()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func momentButtonTouched() {
        savedTimes.append((self.playerController.player!.currentItem?.currentTime())!)
        savedTimes.sortInPlace(){ CMTimeGetSeconds($0) > CMTimeGetSeconds($1) }
        var times = ""
        for time in self.savedTimes.reverse() {
            times = "\(times) \(round(CMTimeGetSeconds(time)))"
        }
        self.momentLabel.text = times
        
    }

    @IBAction func backButtonTouched() {
        
        let now = CMTimeGetSeconds((self.playerController.player!.currentItem?.currentTime())!)
        for time in self.savedTimes.reverse() {
            if CMTimeGetSeconds(time) < now {
                self.playerController.player?.seekToTime(time)
            }
        }
    }

    @IBAction func doubleBackTouched() {
        let now = CMTimeGetSeconds((self.playerController.player!.currentItem?.currentTime())!)
        var  first = true
        for time in self.savedTimes.reverse() {
            if CMTimeGetSeconds(time) < now {
                if first {
                    first = false
                } else {
                    self.playerController.player?.seekToTime(time)
                    break
                }
            }
        }
    }
    @IBAction func forwardButtonTouched() {
        
        let now = CMTimeGetSeconds((self.playerController.player!.currentItem?.currentTime())!)
        for time in self.savedTimes {
            if CMTimeGetSeconds(time) > now {
                self.playerController.player?.seekToTime(time)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

class DVOAVPlayerView: UIView {
    
    var player: AVPlayer?
    
    
}