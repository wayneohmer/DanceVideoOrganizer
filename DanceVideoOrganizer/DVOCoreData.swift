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

    
    lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
       
        let modelURL = Bundle.main.url(forResource: "DanceVideoOrganizer", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
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
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
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

    class func fetchStudios(predicate: NSPredicate? = nil) -> NSFetchedResultsController<Studio> {
        
        let fetchRequest:NSFetchRequest<Studio> = NSFetchRequest(entityName:"Studio")
        let entity = NSEntityDescription.entity(forEntityName: Studio.entityName, in: DVOCoreData.sharedObject.managedObjectContext)
        fetchRequest.entity = entity
        fetchRequest.fetchBatchSize = 0
        let sortDescriptor = NSSortDescriptor(key: StudioAttributes.locationKey, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if predicate != nil {
            fetchRequest.predicate = predicate
        }
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DVOCoreData.sharedObject.managedObjectContext, sectionNameKeyPath: nil, cacheName: "Master")
        
    }
    
    class func fetchEvents(_ predicate: NSPredicate? = nil) -> NSFetchedResultsController<Event> {
        
        let fetchRequest:NSFetchRequest<Event> = NSFetchRequest(entityName:"Event")
        let entity = NSEntityDescription.entity(forEntityName: Event.entityName, in: DVOCoreData.sharedObject.managedObjectContext)
        fetchRequest.entity = entity
        fetchRequest.fetchBatchSize = 0
        let sortDescriptor = NSSortDescriptor(key: EventAttributes.locationKey, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if predicate != nil {
            fetchRequest.predicate = predicate
        }
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DVOCoreData.sharedObject.managedObjectContext, sectionNameKeyPath: nil, cacheName: "Master")
        
    }
    
    class func fetchMetaData(_ predicate: NSPredicate? = nil) -> NSFetchedResultsController<VideoMetaData> {
        
        let fetchRequest:NSFetchRequest<VideoMetaData> = NSFetchRequest(entityName:"VideoMetaData")
        let entity = NSEntityDescription.entity(forEntityName: VideoMetaData.entityName, in: DVOCoreData.sharedObject.managedObjectContext)
        fetchRequest.entity = entity
        fetchRequest.fetchBatchSize = 0
        let sortDescriptor = NSSortDescriptor(key: VideoMetaDataAttributes.date, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if predicate != nil {
            fetchRequest.predicate = predicate
        }
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DVOCoreData.sharedObject.managedObjectContext, sectionNameKeyPath: nil, cacheName: "Master")
    }
    class func fetchCompLevels(_ predicate: NSPredicate? = nil) -> NSFetchedResultsController<CompLevel> {
        
        let fetchRequest:NSFetchRequest<CompLevel> = NSFetchRequest(entityName:"CompLevel")
        let entity = NSEntityDescription.entity(forEntityName: CompLevel.entityName, in: DVOCoreData.sharedObject.managedObjectContext)
        fetchRequest.entity = entity
        fetchRequest.fetchBatchSize = 0
        let sortDescriptor = NSSortDescriptor(key: "levelDesc", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if predicate != nil {
            fetchRequest.predicate = predicate
        }
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DVOCoreData.sharedObject.managedObjectContext, sectionNameKeyPath: nil, cacheName: "Master")
    }
    
    class func fetchCompTypes(_ predicate: NSPredicate? = nil) -> NSFetchedResultsController<CompType> {
        
        let fetchRequest:NSFetchRequest<CompType> = NSFetchRequest(entityName:"CompType")
        let entity = NSEntityDescription.entity(forEntityName: CompType.entityName, in: DVOCoreData.sharedObject.managedObjectContext)
        fetchRequest.entity = entity
        fetchRequest.fetchBatchSize = 0
        let sortDescriptor = NSSortDescriptor(key: "typeDesc", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if predicate != nil {
            fetchRequest.predicate = predicate
        }
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DVOCoreData.sharedObject.managedObjectContext, sectionNameKeyPath: nil, cacheName: "Master")
    }
    
    class func fetchCompRounds(_ predicate: NSPredicate? = nil) -> NSFetchedResultsController<CompRound> {
        
        let fetchRequest:NSFetchRequest<CompRound> = NSFetchRequest(entityName:"CompRound")
        let entity = NSEntityDescription.entity(forEntityName: CompRound.entityName, in: DVOCoreData.sharedObject.managedObjectContext)
        fetchRequest.entity = entity
        fetchRequest.fetchBatchSize = 0
        let sortDescriptor = NSSortDescriptor(key: "roundDesc", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if predicate != nil {
            fetchRequest.predicate = predicate
        }
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DVOCoreData.sharedObject.managedObjectContext, sectionNameKeyPath: nil, cacheName: "Master")
    }
        
    class func fetchDancers() -> NSFetchedResultsController<Dancer> {
        
        let fetchRequest:NSFetchRequest<Dancer> = NSFetchRequest(entityName:"Dancer")
        let entity = NSEntityDescription.entity(forEntityName: Dancer.entityName, in: DVOCoreData.sharedObject.managedObjectContext)
        fetchRequest.entity = entity
        fetchRequest.fetchBatchSize = 0
        let sortDescriptor = NSSortDescriptor(key: DancerAttributes.name, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DVOCoreData.sharedObject.managedObjectContext, sectionNameKeyPath: nil, cacheName: "Master")
        
    }
    
    class func fetchVideoAssetWithIdentifier(_ indentifier: String) -> VideoAssets {
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        let entity = NSEntityDescription.entity(forEntityName: VideoAssets.entityName, in: DVOCoreData.sharedObject.managedObjectContext)
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
