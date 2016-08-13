//
//  CompType.swift
//  DanceVideoOrganizer
//
//  Created by Wayne Ohmer on 6/16/16.
//  Copyright © 2016 Wayne Ohmer. All rights reserved.
//

import Foundation
import CoreData


class CompType: NSManagedObject, SearchableName  {
    
    static let entityName = "CompType"

    @NSManaged var typeDesc: String?
    @NSManaged var metaData: Set<VideoMetaData>?

    var searchableName: String {
        return self.typeDesc ?? ""
    }
}
