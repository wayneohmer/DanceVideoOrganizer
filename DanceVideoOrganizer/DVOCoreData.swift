//
//  DVOCoreData.swift
//  DanceVideoOrganizer
//
//  Created by Wayne Ohmer on 5/26/16.
//  Copyright © 2016 Wayne Ohmer. All rights reserved.
//

import UIKit
import CoreData
import Photos

class DVOCoreData: NSObject {
    
    static var sharedObject = DVOCoreData()
    static var foundAddresses = [String:String]()

    
    lazy var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
       
        let modelURL = NSBundle.mainBundle().URLForResource("DanceVideoOrganizer", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }

    class func fetchStudios(predicate: NSPredicate? = nil) -> NSFetchedResultsController {
        
        let fetchRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName(Studio.entityName, inManagedObjectContext: DVOCoreData.sharedObject.managedObjectContext)
        fetchRequest.entity = entity
        fetchRequest.fetchBatchSize = 0
        let sortDescriptor = NSSortDescriptor(key: StudioAttributes.locationKey, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if predicate != nil {
            fetchRequest.predicate = predicate
        }
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DVOCoreData.sharedObject.managedObjectContext, sectionNameKeyPath: nil, cacheName: "Master")
        
    }
    
    class func fetchEvents(predicate: NSPredicate? = nil) -> NSFetchedResultsController {
        
        let fetchRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName(Event.entityName, inManagedObjectContext: DVOCoreData.sharedObject.managedObjectContext)
        fetchRequest.entity = entity
        fetchRequest.fetchBatchSize = 0
        let sortDescriptor = NSSortDescriptor(key: EventAttributes.locationKey, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if predicate != nil {
            fetchRequest.predicate = predicate
        }
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DVOCoreData.sharedObject.managedObjectContext, sectionNameKeyPath: nil, cacheName: "Master")
        
    }
    
    class func fetchMetaData(predicate: NSPredicate? = nil) -> NSFetchedResultsController {
        
        let fetchRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName(VideoMetaData.entityName, inManagedObjectContext: DVOCoreData.sharedObject.managedObjectContext)
        fetchRequest.entity = entity
        fetchRequest.fetchBatchSize = 0
        let sortDescriptor = NSSortDescriptor(key: VideoMetaDataAttributes.date, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if predicate != nil {
            fetchRequest.predicate = predicate
        }
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DVOCoreData.sharedObject.managedObjectContext, sectionNameKeyPath: nil, cacheName: "Master")
    }
    class func fetchCompLevels(predicate: NSPredicate? = nil) -> NSFetchedResultsController {
        
        let fetchRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName(CompLevel.entityName, inManagedObjectContext: DVOCoreData.sharedObject.managedObjectContext)
        fetchRequest.entity = entity
        fetchRequest.fetchBatchSize = 0
        let sortDescriptor = NSSortDescriptor(key: "levelDesc", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if predicate != nil {
            fetchRequest.predicate = predicate
        }
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DVOCoreData.sharedObject.managedObjectContext, sectionNameKeyPath: nil, cacheName: "Master")
    }
    
    class func fetchCompTypes(predicate: NSPredicate? = nil) -> NSFetchedResultsController {
        
        let fetchRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName(CompType.entityName, inManagedObjectContext: DVOCoreData.sharedObject.managedObjectContext)
        fetchRequest.entity = entity
        fetchRequest.fetchBatchSize = 0
        let sortDescriptor = NSSortDescriptor(key: "typeDesc", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if predicate != nil {
            fetchRequest.predicate = predicate
        }
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DVOCoreData.sharedObject.managedObjectContext, sectionNameKeyPath: nil, cacheName: "Master")
    }
    
    class func fetchCompRounds(predicate: NSPredicate? = nil) -> NSFetchedResultsController {
        
        let fetchRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName(CompRound.entityName, inManagedObjectContext: DVOCoreData.sharedObject.managedObjectContext)
        fetchRequest.entity = entity
        fetchRequest.fetchBatchSize = 0
        let sortDescriptor = NSSortDescriptor(key: "roundDesc", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if predicate != nil {
            fetchRequest.predicate = predicate
        }
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DVOCoreData.sharedObject.managedObjectContext, sectionNameKeyPath: nil, cacheName: "Master")
    }
        
    class func fetchDancers() -> NSFetchedResultsController {
        
        let fetchRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName(Dancer.entityName, inManagedObjectContext: DVOCoreData.sharedObject.managedObjectContext)
        fetchRequest.entity = entity
        fetchRequest.fetchBatchSize = 0
        let sortDescriptor = NSSortDescriptor(key: DancerAttributes.name, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DVOCoreData.sharedObject.managedObjectContext, sectionNameKeyPath: nil, cacheName: "Master")
        
    }
    
    class func fetchVideoAssetWithIdentifier(indentifier: String) -> VideoAssets {
        let fetchRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName(VideoAssets.entityName, inManagedObjectContext: DVOCoreData.sharedObject.managedObjectContext)
        fetchRequest.entity = entity
        fetchRequest.fetchBatchSize = 0
        let sortDescriptor = NSSortDescriptor(key: VideoAssetsAttributes.localIdentifier, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = NSPredicate(format: "localIdentifier = \"\(indentifier)\"")
        let fetchController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DVOCoreData.sharedObject.managedObjectContext, sectionNameKeyPath: nil, cacheName: "Master")
        do {
            try fetchController.performFetch()
            if let assets = fetchController.fetchedObjects as? [VideoAssets] {
                for asset in assets {
                    return asset
                }
            }
        } catch {
            print("failed to fetch VideoAsset")
        }
        //ToDo handle error.
        return VideoAssets()
    }
    
 }
