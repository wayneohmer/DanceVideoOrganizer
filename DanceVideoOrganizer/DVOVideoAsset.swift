//
//  DVOVideoAsset.swift
//  CoreDataPractice
//
//  Created by Wayne Ohmer on 5/12/16.
//  Copyright © 2016 Wayne Ohmer. All rights reserved.
//

import UIKit
import Photos

class DVOVideoAsset {
    var videoAsset: AVAsset?
    var asset = PHAsset()
    var thumbNail = UIImage()
    var address = ""
    var assetLocalIdentifier = ""
    var locationName = ""
    var locationKey = ""
    var instructors = ""
    var creationDate = Date()
}
