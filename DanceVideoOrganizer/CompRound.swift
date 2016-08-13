//
//  CompRound.swift
//  DanceVideoOrganizer
//
//  Created by Wayne Ohmer on 6/16/16.
//  Copyright © 2016 Wayne Ohmer. All rights reserved.
//

import Foundation
import CoreData


class CompRound: NSManagedObject, SearchableName {
    
    static let entityName = "CompRound"

    @NSManaged var roundDesc: String?
    @NSManaged var metaData: Set<VideoMetaData>?
    
    var searchableName: String {
        return self.roundDesc ?? ""
    }
    
}
