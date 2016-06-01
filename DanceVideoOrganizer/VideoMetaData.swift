//
//  VideoMetaData.swift
//  DanceVideoOrganizer
//
//  Created by Wayne Ohmer on 5/27/16.
//  Copyright © 2016 Wayne Ohmer. All rights reserved.
//

import Foundation
import CoreData

public class VideoMetaData: NSManagedObject {
    
    @NSManaged var title: String?
    @NSManaged var type: String?
    @NSManaged var leader: String?
    @NSManaged var follower: String?
    @NSManaged var location: String?
    @NSManaged var asset: VideoAssets?
    @NSManaged var studio: Studio?

// Insert code here to add functionality to your managed object subclass

}
