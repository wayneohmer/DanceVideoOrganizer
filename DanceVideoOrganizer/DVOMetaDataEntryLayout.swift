//
//  DVOMetaDataEntryLayout.swift
//  DanceVideoOrganizer
//
//  Created by Wayne Ohmer on 6/1/16.
//  Copyright © 2016 Wayne Ohmer. All rights reserved.
//

import UIKit
import CoreData

class DVOMetaDataEntryLayout: NSObject {
    
    struct CellData {
        var description = ""
        var data = ""
        var visible = true
        var destination:((navController: UINavigationController?) -> ())? = nil
    }
    
    var cellDict = [String:CellData]()
    let cellOrder = [VideoMetaDataAttributes.title,VideoMetaDataAttributes.location,VideoMetaDataAttributes.instructors,VideoMetaDataAttributes.date,VideoMetaDataAttributes.CompRound]
    var metaData = VideoMetaData(entity: NSEntityDescription.entityForName(VideoMetaData.entityName, inManagedObjectContext: DVOCoreData.sharedObject.managedObjectContext)!, insertIntoManagedObjectContext: DVOCoreData.sharedObject.managedObjectContext)
    let mainStoryboard = UIStoryboard(name:"Main", bundle: nil)

    convenience init(videoAsset: DVOVideoAsset) {
        self.init()
        var instructorName = ""
        let fetchedResultsController = DVOCoreData.fetchStudios(NSPredicate(format: "name = \"\(videoAsset.locationName)\" "))
        do {
            try fetchedResultsController.performFetch()
            if let studios = fetchedResultsController.fetchedObjects as? [Studio] {
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
                if let events = fetchedResultsController.fetchedObjects as? [Event] {
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
                         VideoMetaDataAttributes.instructors: CellData(description: "Instructor(s):", data: instructorName, visible: true, destination: self.handleInstructor),
                         VideoMetaDataAttributes.CompRound: CellData(description: "Comp:", data: "", visible: false, destination: self.handleComp),
                         VideoMetaDataAttributes.date: CellData(description: "Date:", data: DVODateFormatter.formattedDate(self.metaData.date), visible: true, destination: self.handleDate)]
    
    }
    
    func handleTitle(navController: UINavigationController?) {
        let vc = self.mainStoryboard.instantiateViewControllerWithIdentifier("DVOMetaDataTitleViewController") as! DVOMetaDataTitleViewController
        vc.metaData = self.metaData
        navController?.pushViewController(vc, animated: true)
    }
    
    func handleLocation(navController: UINavigationController?) {
        let vc = self.mainStoryboard.instantiateViewControllerWithIdentifier("DVOLocationTableViewController") as! DVOLocationTableViewController
        vc.metaData = self.metaData
        navController?.pushViewController(vc, animated: true)
    }
    
    func handleInstructor(navController: UINavigationController?) {
        let vc = self.mainStoryboard.instantiateViewControllerWithIdentifier("DVODancerTableViewController") as! DVODancerTableViewController
        vc.metaData = self.metaData
        if let instructors = self.metaData.instructors  {
            vc.selectedDancers = [String:Dancer]()
            for dancer in instructors {
                vc.selectedDancers?[dancer.name!] = dancer             }
        }
        navController?.pushViewController(vc, animated: true)
    }
    
    func handleDate(navController: UINavigationController?){
        let vc = self.mainStoryboard.instantiateViewControllerWithIdentifier("DVODateEntryViewController") as! DVODateEntryViewController
        vc.metaData = self.metaData
        navController?.pushViewController(vc, animated: true)
    }
    
    func handleComp(navController: UINavigationController?) {
        let vc = self.mainStoryboard.instantiateViewControllerWithIdentifier("DVOCompEditViewController") as! DVOCompEditViewController
        vc.metaData = self.metaData
        navController?.pushViewController(vc, animated: true)
    }
    
    func handleTypeChange(type: Int) {
        switch type {
        case 0:
            self.cellDict[VideoMetaDataAttributes.instructors]?.description = "Instructor(s):"
            self.cellDict[VideoMetaDataAttributes.CompRound]?.visible = false
        case 1:
            self.cellDict[VideoMetaDataAttributes.instructors]?.description = "Dancer(s):"
            self.cellDict[VideoMetaDataAttributes.CompRound]?.visible = true
        case 2:
            self.cellDict[VideoMetaDataAttributes.instructors]?.description = "Dancer(s):"
            self.cellDict[VideoMetaDataAttributes.CompRound]?.visible = false
            break
        default:
            break
        }
    }
    
    func updateCells() -> [CellData] {
        self.cellDict[VideoMetaDataAttributes.title]!.data = self.metaData.title ?? ""
        self.cellDict[VideoMetaDataAttributes.location]!.data = self.metaData.location ?? ""
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
        self.cellDict[VideoMetaDataAttributes.instructors]!.data = intructorNames.joinWithSeparator(", ")
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
