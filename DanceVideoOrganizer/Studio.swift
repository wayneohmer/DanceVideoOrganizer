//
//  Studio.swift
//  DanceVideoOrganizer
//
//  Created by Wayne Ohmer on 5/27/16.
//  Copyright © 2016 Wayne Ohmer. All rights reserved.
//

import Foundation
import CoreData

public struct StudioAttributes {
    static let address = "address"
    static let locationKey = "locationKey"
    static let name = "name"
    static let metaData = "metaData"
    static let instructors = "instructors"
    static let defaultInstructor = "defaultInstructor"
}

public class Studio: NSManagedObject, SearchableName {

    static let entityName = "Studio"
    @NSManaged var address: String?
    @NSManaged var name: String?
    @NSManaged var locationKey: String?
    @NSManaged var metaData: Set<VideoMetaData>?
    @NSManaged var instructors: NSSet?
    @NSManaged var defaultInstructor: Dancer?
    
    var searchableName: String { 
        return self.name ?? ""
    }

}
