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
    let cellOrder = [VideoMetaDataAttributes.title,VideoMetaDataAttributes.location,VideoMetaDataAttributes.instructors,VideoAssetsAttributes.createdDate]
    var metaData = VideoMetaData(entity: NSEntityDescription.entityForName(VideoMetaData.entityName, inManagedObjectContext: DVOCoreData.sharedObject.managedObjectContext)!, insertIntoManagedObjectContext: DVOCoreData.sharedObject.managedObjectContext)
    let mainStoryboard = UIStoryboard(name:"Main", bundle: nil)

    convenience init(videoAsset: DVOVideoAsset) {
        self.init()
        let fetchRequest = NSFetchRequest()
        let locationEntity = NSEntityDescription.entityForName(Studio.entityName, inManagedObjectContext: DVOCoreData.sharedObject.managedObjectContext)
        fetchRequest.entity = locationEntity
        fetchRequest.fetchBatchSize = 0
        let sortDescriptor = NSSortDescriptor(key: StudioAttributes.locationKey, ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = NSPredicate(format: "name = \"\(videoAsset.locationName)\" ")
        var instructorName = ""
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DVOCoreData.sharedObject.managedObjectContext, sectionNameKeyPath: nil, cacheName: "Master")
        
        do {
            try fetchedResultsController.performFetch()
            if let studios = fetchedResultsController.fetchedObjects as? [Studio] {
                for studio in studios {
                    instructorName = studio.defaultInstructor?.name ?? ""
                    self.metaData.studio = studio
                }
            }
        } catch {
            
        }
        self.cellDict = [VideoMetaDataAttributes.title:CellData(description: "Title:", data: self.metaData.title ?? "", visible: true, destination: self.handleTitle),
                         VideoMetaDataAttributes.location:CellData(description: "Location:", data: self.metaData.studio?.name ?? "", visible: true, destination: self.handleLocation),
                         VideoMetaDataAttributes.instructors:CellData(description: "Instructor(s):", data: instructorName, visible: true, destination: self.handleInstructor),
                         VideoAssetsAttributes.createdDate:CellData(description: "Date:", data: DVODateFormatter.formattedDate(videoAsset.creationDate), visible: true, destination: nil)]
        }
    
    func handleTitle(navController: UINavigationController?) {
        let vc = self.mainStoryboard.instantiateViewControllerWithIdentifier("DVOMetaDataTitleViewController") as! DVOMetaDataTitleViewController
        vc.metaData = self.metaData
        navController?.pushViewController(vc, animated: true)
    }
    
    func handleLocation(navController: UINavigationController?) {
        let vc = self.mainStoryboard.instantiateViewControllerWithIdentifier("DVOLocationTableViewController") as! DVOLocationTableViewController
        vc.metaData = self.metaData
        vc.selectedStudio = self.metaData.studio!
        navController?.pushViewController(vc, animated: true)
    }
    
    func handleInstructor(navController: UINavigationController?) {
        let vc = self.mainStoryboard.instantiateViewControllerWithIdentifier("DVODancerTableViewController") as! DVODancerTableViewController
        vc.metaData = self.metaData
        vc.selectedDancer = self.metaData.studio?.defaultInstructor
        navController?.pushViewController(vc, animated: true)
    }
    
    func updateCells() -> [CellData] {
        self.cellDict[VideoMetaDataAttributes.title]!.data = self.metaData.title ?? ""
        self.cellDict[VideoMetaDataAttributes.location]!.data = self.metaData.studio?.name ?? ""
        var returnArray = [CellData]()
        for key in self.cellOrder {
            returnArray.append(self.cellDict[key]!)
        }
        return returnArray
    }
    
}
