//
//  VideoMetaData.swift
//  DanceVideoOrganizer
//
//  Created by Wayne Ohmer on 5/27/16.
//  Copyright © 2016 Wayne Ohmer. All rights reserved.
//

import UIKit
import CoreData
import Photos
import AVKit

public struct VideoMetaDataAttributes {
    static let title = "title"
    static let type = "type"
    static let leader = "leader"
    static let follower = "follower"
    static let location = "location"
    static let date = "date"
    static let asset = "asset"
    static let studio = "studio"
    static let instructors = "instructors"
    static let CompRound = "CompRound"
    static let CompLevel = "CompLevel"
    static let CompType = "CompType"

}

public class VideoMetaData: NSManagedObject {
    
    static let entityName = "VideoMetaData"
    @NSManaged var title: String?
    @NSManaged var type: String?
    @NSManaged var date: NSDate?
    @NSManaged var compRound: CompRound?
    @NSManaged var compLevel: Set<CompLevel>?
    @NSManaged var compType: CompType?
    @NSManaged var asset: VideoAssets?
    @NSManaged var studio: Studio?
    @NSManaged var event: Event?
    @NSManaged var instructors: Set<Dancer>?
    
    var thumbnail: UIImage?
    var avAsset: AVAsset?
    
    var location: String {
        get {
            if let thisStudio = self.studio {
                return thisStudio.name ?? ""
            }
            if let thisEvent = self.event {
                return thisEvent.name ?? ""
            }
            return ""
        }
    }
    
    var dancers: String {
        var returnString = ""
        if let dancers = self.instructors {
            var names = [String]()
            for dancer in dancers {
                names.append(dancer.name ?? "")
            }
            returnString = names.joinWithSeparator(", ")
        }
        return returnString
    }

    var compDescription: String {
        var returnString = ""
        
        if let levels = self.compLevel {
            var levelsArray = [String]()
            for level in levels {
                levelsArray.append(level.levelDesc ?? "")
            }
            returnString = "\(levelsArray.joinWithSeparator("/")) "
        }
        if let typeDesc = self.compType?.typeDesc {
            returnString = "\(returnString)\(typeDesc) "
        }
        if let roundDesc = self.compRound?.roundDesc {
            returnString = "\(returnString)\(roundDesc) "
        }
        return returnString
    }
}
