//
//  CompLevel.swift
//  DanceVideoOrganizer
//
//  Created by Wayne Ohmer on 6/16/16.
//  Copyright © 2016 Wayne Ohmer. All rights reserved.
//

import Foundation
import CoreData


class CompLevel: NSManagedObject, SearchableName {

    static let entityName = "CompLevel"

    @NSManaged var levelDesc: String?
    @NSManaged var metaData: Set<VideoMetaData>?

    var searchableName: String {
        return self.levelDesc ?? ""
    }

}
