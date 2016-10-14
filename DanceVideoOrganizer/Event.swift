//
//  Event.swift
//  DanceVideoOrganizer
//
//  Created by Wayne Ohmer on 6/15/16.
//  Copyright © 2016 Wayne Ohmer. All rights reserved.
//

import Foundation
import CoreData

public struct EventAttributes {
    static let name = "name"
    static let locationKey = "locationKey"
    static let startDate = "startDate"
    static let endDate = "endDate"
    static let address = "address"
    static let instructors = "instructors"
    static let metaData = "metaData"
}

class Event: NSManagedObject, SearchableName {
    
    static let entityName = "Event"
    @NSManaged var name: String?
    @NSManaged var locationKey: String?
    @NSManaged var startDate: Date?
    @NSManaged var endDate: Date?
    @NSManaged var address: String?
    @NSManaged var instructors: Set<Dancer>?
    @NSManaged var metaData: Set<VideoMetaData>?

    var searchableName: String {
        return self.name ?? ""
    }

}
