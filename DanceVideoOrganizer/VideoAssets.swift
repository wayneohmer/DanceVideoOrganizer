//
//  VideoAssets.swift
//  DanceVideoOrganizer
//
//  Created by Wayne Ohmer on 5/27/16.
//  Copyright © 2016 Wayne Ohmer. All rights reserved.
//

import Foundation
import CoreData
import Photos

public struct VideoAssetsAttributes {
    static let address = "address"
    static let createdDate = "createdDate"
    static let localIdentifier = "localIdentifier"
    static let locationKey = "locationKey"
}

open class VideoAssets: NSManagedObject {
    
    static let entityName = "VideoAssets"
    @NSManaged var address: String?
    @NSManaged var createdDate: Date?
    @NSManaged var localIdentifier: String?
    @NSManaged var locationKey: String?
    @NSManaged var metaData: VideoMetaData?
    

}
