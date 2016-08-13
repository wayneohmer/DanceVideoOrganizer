//
//  Dancer.swift
//  DanceVideoOrganizer
//
//  Created by Wayne Ohmer on 6/1/16.
//  Copyright © 2016 Wayne Ohmer. All rights reserved.
//

import Foundation
import CoreData

public struct DancerAttributes {
    static let name = "name"
    static let primaryRole = "primaryRole"
    static let studio = "studio"
    static let defaultStudio = "defaultStudio"
    static let metaData = "metaData"
}

class Dancer: NSManagedObject {
    
    static let entityName = "Dancer"
    @NSManaged var name: String?
    @NSManaged var primaryRole: String?
    @NSManaged var studio: NSSet?
    @NSManaged var defaultStudio: NSSet?
    @NSManaged var metaData: Set<VideoMetaData>?

}
