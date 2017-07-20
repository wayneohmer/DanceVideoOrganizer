//
//  DVOMetaDataEntryLayout.swift
//  DanceVideoOrganizer
//
//  Created by Wayne Ohmer on 6/1/16.
//  Copyright © 2016 Wayne Ohmer. All rights reserved.
//

import UIKit
import CoreData

enum VideoClassification: Int {
    case instructional = 0, competition, inspirational
}

class DVOMetaDataEntryLayout: NSObject {
    
    struct CellData {
        var description = ""
        var data = ""
        var visible = true
        var destination:((_ navController: UINavigationController?) -> ())? = nil
    }
    
    var cellDict = [String:CellData]()
    let cellOrder = [VideoMetaDataAttributes.title,VideoMetaDataAttributes.location,VideoMetaDataAttributes.instructors,VideoMetaDataAttributes.date,VideoMetaDataAttributes.CompRound]
    var metaData = VideoMetaData(entity: NSEntityDescription.entity(forEntityName: VideoMetaData.entityName, in: DVOCoreData.sharedObject.managedObjectContext)!, insertInto: DVOCoreData.sharedObject.managedObjectContext)
    let mainStoryboard = UIStoryboard(name:"Main", bundle: nil)

    convenience init(videoAsset: DVOVideoAsset) {
        self.init()
        var instructorName = ""
        let fetchedResultsController = DVOCoreData.fetchStudios(predicate: NSPredicate(format: "name = \"\(videoAsset.locationName)\" "))
        do {
            try fetchedResultsController.performFetch()
            if let studios = fetchedResultsController.fetchedObjects as [Studio]? {
                for studio in studios {
                    if let defautInstructor = studio.defaultInstructor {
                        instructorName = defautInstructor.name ?? ""
                        self.metaData.instructors = Set([defautInstructor])
                    }
                    self.metaData.studio = studio
                }
            }
        } catch {
            
        }
        if self.metaData.studio == nil {
            let fetchedResultsController = DVOCoreData.fetchEvents(NSPredicate(format: "name = \"\(videoAsset.locationName)\" "))
            do {
                try fetchedResultsController.performFetch()
                if let events = fetchedResultsController.fetchedObjects as [Event]? {
                    for event in events {
                        self.metaData.event = event
                    }
                }
            } catch {
                
            }
        }
        self.metaData.date = videoAsset.creationDate
        let asset = DVOCoreData.fetchVideoAssetWithIdentifier(videoAsset.assetLocalIdentifier)
        self.metaData.asset = asset
        
        self.cellDict = [VideoMetaDataAttributes.title: CellData(description: "Title:", data: self.metaData.title ?? "", visible: true, destination: self.handleTitle),
                         VideoMetaDataAttributes.location: CellData(description: "Location:", data: self.metaData.location, visible: true, destination: self.handleLocation),
                         VideoMetaDataAttributes.instructors: CellData(description: "Instructor:", data: instructorName, visible: true, destination: self.handleInstructor),
                         VideoMetaDataAttributes.CompRound: CellData(description: "Comp:", data: "", visible: false, destination: self.handleComp),
                         VideoMetaDataAttributes.date: CellData(description: "Date:", data: DVODateFormatter.formattedDate(self.metaData.date), visible: true, destination: self.handleDate)]
    
    }
    
    func handleTitle(_ navController: UINavigationController?) {
        let vc = self.mainStoryboard.instantiateViewController(withIdentifier: "DVOMetaDataTitleViewController") as! DVOMetaDataTitleViewController
        vc.metaData = self.metaData
        navController?.pushViewController(vc, animated: true)
    }
    
    func handleLocation(_ navController: UINavigationController?) {
        let vc = self.mainStoryboard.instantiateViewController(withIdentifier: "DVOLocationTableViewController") as! DVOLocationTableViewController
        vc.metaData = self.metaData
        navController?.pushViewController(vc, animated: true)
    }
    
    func handleInstructor(_ navController: UINavigationController?) {
        let vc = self.mainStoryboard.instantiateViewController(withIdentifier: "DVODancerTableViewController") as! DVODancerTableViewController
        vc.metaData = self.metaData
        if let instructors = self.metaData.instructors  {
            vc.selectedDancers = [String:Dancer]()
            for dancer in instructors {
                vc.selectedDancers?[dancer.name!] = dancer             }
        }
        navController?.pushViewController(vc, animated: true)
    }
    
    func handleDate(_ navController: UINavigationController?){
        let vc = self.mainStoryboard.instantiateViewController(withIdentifier: "DVODateEntryViewController") as! DVODateEntryViewController
        vc.metaData = self.metaData
        navController?.pushViewController(vc, animated: true)
    }
    
    func handleComp(_ navController: UINavigationController?) {
        let vc = self.mainStoryboard.instantiateViewController(withIdentifier: "DVOCompEditViewController") as! DVOCompEditViewController
        vc.metaData = self.metaData
        navController?.pushViewController(vc, animated: true)
    }
    
    func handleTypeChange(_ type: Int) {
        let classification:VideoClassification = VideoClassification(rawValue: type) ?? VideoClassification.instructional
        switch classification {
        case .instructional :
            self.cellDict[VideoMetaDataAttributes.instructors]?.description = "Instructor:"
            self.cellDict[VideoMetaDataAttributes.CompRound]?.visible = false
            self.cellDict[VideoMetaDataAttributes.title]?.visible = true

        case .competition:
            self.cellDict[VideoMetaDataAttributes.instructors]?.description = "Dancer:"
            self.cellDict[VideoMetaDataAttributes.CompRound]?.visible = true
            self.cellDict[VideoMetaDataAttributes.title]?.visible = false
            
        case .inspirational:
            self.cellDict[VideoMetaDataAttributes.instructors]?.description = "Dancer:"
            self.cellDict[VideoMetaDataAttributes.CompRound]?.visible = false
            self.cellDict[VideoMetaDataAttributes.title]?.visible = true

        }
    }
    
    func updateCells() -> [CellData] {
        self.cellDict[VideoMetaDataAttributes.title]!.data = self.metaData.title ?? ""
        self.cellDict[VideoMetaDataAttributes.location]!.data = self.metaData.location
        var intructorNames = [String]()
        if let dancers = self.metaData.instructors {
            if !dancers.isEmpty {
                for dancer in dancers {
                    intructorNames.append(dancer.name!)
                }
            }
            else if let defaultInstructor = self.metaData.studio?.defaultInstructor?.name {
                intructorNames = [defaultInstructor]
                self.metaData.instructors = Set([self.metaData.studio!.defaultInstructor!])
            }
        }
        if (self.metaData.instructors?.count)! > 1 {
            self.cellDict[VideoMetaDataAttributes.instructors]?.description = self.cellDict[VideoMetaDataAttributes.instructors]?.description.replacingOccurrences(of: "r:", with: "rs:") ?? ""
        } else {
            self.cellDict[VideoMetaDataAttributes.instructors]?.description = self.cellDict[VideoMetaDataAttributes.instructors]?.description.replacingOccurrences(of: "rs:", with: "r:") ?? ""
        }
        self.cellDict[VideoMetaDataAttributes.instructors]!.data = intructorNames.joined(separator: ", ")
        self.cellDict[VideoMetaDataAttributes.date]!.data = DVODateFormatter.formattedDate(self.metaData.date)
        self.cellDict[VideoMetaDataAttributes.CompRound]!.data = self.metaData.compDescription
        var returnArray = [CellData]()
        for key in self.cellOrder {
            if self.cellDict[key]!.visible {
                returnArray.append(self.cellDict[key]!)
            }
        }
        return returnArray
    }
    
}
