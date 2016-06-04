//
//  VideoMetaData.swift
//  DanceVideoOrganizer
//
//  Created by Wayne Ohmer on 5/27/16.
//  Copyright © 2016 Wayne Ohmer. All rights reserved.
//

import Foundation
import CoreData

public struct VideoMetaDataAttributes {
    static let title = "title"
    static let type = "type"
    static let leader = "leader"
    static let follower = "follower"
    static let location = "location"
    static let asset = "asset"
    static let studio = "studio"
    static let instructors = "instructors"

}


public class VideoMetaData: NSManagedObject {
    
    static let entityName = "VideoMetaData"
    @NSManaged var title: String?
    @NSManaged var type: String?
    @NSManaged var leader: String?
    @NSManaged var follower: String?
    @NSManaged var location: String?
    @NSManaged var asset: VideoAssets?
    @NSManaged var studio: Studio?
    @NSManaged var instructors: NSSet?

}
