//
//  AppDelegate.swift
//  DanceVideoOrganizer
//
//  Created by Wayne Ohmer on 5/26/16.
//  Copyright © 2016 Wayne Ohmer. All rights reserved.
//

import UIKit
import CoreData
import Photos


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var persistentStoreCoordinator = DVOCoreData().persistentStoreCoordinator
    
    var dancerDict = [String:Dancer]()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.populateLocalVideoData()
        //self.populateNew()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        DVOCoreData.sharedObject.saveContext()
    }
    
    func populateNew() {
        self.populateComps()
        self.populateDancers()
        self.populateStudioData()
    }
    
    func populateComps() {
        let complevelEntity = NSEntityDescription.entity(forEntityName: CompLevel.entityName, in: DVOCoreData.sharedObject.managedObjectContext)
        var newLevel = CompLevel(entity: complevelEntity!, insertInto: DVOCoreData.sharedObject.managedObjectContext)
        newLevel.levelDesc = "New Comer"
        newLevel = CompLevel(entity: complevelEntity!, insertInto: DVOCoreData.sharedObject.managedObjectContext)
        newLevel.levelDesc = "Novice"
        newLevel = CompLevel(entity: complevelEntity!, insertInto: DVOCoreData.sharedObject.managedObjectContext)
        newLevel.levelDesc = "Intermediate"
        newLevel = CompLevel(entity: complevelEntity!, insertInto: DVOCoreData.sharedObject.managedObjectContext)
        newLevel.levelDesc = "Advanced"
        newLevel = CompLevel(entity: complevelEntity!, insertInto: DVOCoreData.sharedObject.managedObjectContext)
        newLevel.levelDesc = "All Star"
        newLevel = CompLevel(entity: complevelEntity!, insertInto: DVOCoreData.sharedObject.managedObjectContext)
        newLevel.levelDesc = "Sophisticated"
        newLevel = CompLevel(entity: complevelEntity!, insertInto: DVOCoreData.sharedObject.managedObjectContext)
        newLevel.levelDesc = "Masters"
        newLevel = CompLevel(entity: complevelEntity!, insertInto: DVOCoreData.sharedObject.managedObjectContext)
        newLevel.levelDesc = "Open"
        
        let compTypeEntity = NSEntityDescription.entity(forEntityName: CompType.entityName, in: DVOCoreData.sharedObject.managedObjectContext)
        var newType = CompType(entity: compTypeEntity!, insertInto: DVOCoreData.sharedObject.managedObjectContext)
        newType.typeDesc = "Jack & Jill"
        newType = CompType(entity: compTypeEntity!, insertInto: DVOCoreData.sharedObject.managedObjectContext)
        newType.typeDesc = "Strictly"
        newType = CompType(entity: compTypeEntity!, insertInto: DVOCoreData.sharedObject.managedObjectContext)
        newType.typeDesc = "All American"
        
        let compRoundEntity = NSEntityDescription.entity(forEntityName: CompRound.entityName, in: DVOCoreData.sharedObject.managedObjectContext)
        var newRound = CompRound(entity: compRoundEntity!, insertInto: DVOCoreData.sharedObject.managedObjectContext)
        newRound.roundDesc = "Prelims"
        newRound = CompRound(entity: compRoundEntity!, insertInto: DVOCoreData.sharedObject.managedObjectContext)
        newRound.roundDesc = "Semi-Finals"
        newRound = CompRound(entity: compRoundEntity!, insertInto: DVOCoreData.sharedObject.managedObjectContext)
        newRound.roundDesc = "Quarter-Finals"
        newRound = CompRound(entity: compRoundEntity!, insertInto: DVOCoreData.sharedObject.managedObjectContext)
        newRound.roundDesc = "Finals"
        
    }
    
    func populateDancers() {
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: Dancer.entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try self.persistentStoreCoordinator.execute(deleteRequest, with: DVOCoreData.sharedObject.managedObjectContext)
        } catch let error as NSError {
            print(error)
        }
        let dancerEntity = NSEntityDescription.entity(forEntityName: Dancer.entityName, in: DVOCoreData.sharedObject.managedObjectContext)

        var newDancer = Dancer(entity: dancerEntity!, insertInto: DVOCoreData.sharedObject.managedObjectContext)
        newDancer.name = "Leilani Nakagawa"
        self.dancerDict[newDancer.name!] = newDancer
        newDancer = Dancer(entity: dancerEntity!, insertInto: DVOCoreData.sharedObject.managedObjectContext)
        newDancer.name = "Ariel Caplan"
        self.dancerDict[newDancer.name!] = newDancer
        newDancer = Dancer(entity: dancerEntity!, insertInto: DVOCoreData.sharedObject.managedObjectContext)
        newDancer.name = "Joe Broderick"
        self.dancerDict[newDancer.name!] = newDancer
        newDancer = Dancer(entity: dancerEntity!, insertInto: DVOCoreData.sharedObject.managedObjectContext)
        newDancer.name = "Marcus Sterling"
        self.dancerDict[newDancer.name!] = newDancer
        newDancer = Dancer(entity: dancerEntity!, insertInto: DVOCoreData.sharedObject.managedObjectContext)
        newDancer.name = "Trina Siebert"
        self.dancerDict[newDancer.name!] = newDancer
        newDancer = Dancer(entity: dancerEntity!, insertInto: DVOCoreData.sharedObject.managedObjectContext)
        newDancer.name = "Jon Jackson"
        self.dancerDict[newDancer.name!] = newDancer
        newDancer = Dancer(entity: dancerEntity!, insertInto: DVOCoreData.sharedObject.managedObjectContext)
        newDancer.name = "Cassie Winter"
        self.dancerDict[newDancer.name!] = newDancer
        newDancer = Dancer(entity: dancerEntity!, insertInto: DVOCoreData.sharedObject.managedObjectContext)
        newDancer.name = "Kyle Red"
        self.dancerDict[newDancer.name!] = newDancer
        newDancer = Dancer(entity: dancerEntity!, insertInto: DVOCoreData.sharedObject.managedObjectContext)
        newDancer.name = "Sara Van Drake"
        self.dancerDict[newDancer.name!] = newDancer
        newDancer = Dancer(entity: dancerEntity!, insertInto: DVOCoreData.sharedObject.managedObjectContext)
        newDancer.name = "Wayne Ohmer"
        self.dancerDict[newDancer.name!] = newDancer
        newDancer = Dancer(entity: dancerEntity!, insertInto: DVOCoreData.sharedObject.managedObjectContext)
        newDancer.name = "Janine Ohmer"
        self.dancerDict[newDancer.name!] = newDancer

    }
    
    func populateStudioData() {
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: Studio.entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try self.persistentStoreCoordinator.execute(deleteRequest, with: DVOCoreData.sharedObject.managedObjectContext)
        } catch let error as NSError {
            print(error)
        }
        let studioEntity = NSEntityDescription.entity(forEntityName: Studio.entityName, in: DVOCoreData.sharedObject.managedObjectContext)
        
        var studio = Studio(entity: studioEntity!, insertInto: DVOCoreData.sharedObject.managedObjectContext)
        studio.name = "Sea To Sky"
        studio.locationKey = "4744.0:-12229.0"
        
        studio = Studio(entity: studioEntity!, insertInto: DVOCoreData.sharedObject.managedObjectContext)
        studio.name = "Bridge Town"
        studio.locationKey = "4562.0:-12267.0"
        
        studio = Studio(entity: studioEntity!, insertInto: DVOCoreData.sharedObject.managedObjectContext)
        studio.name = "Uptown Ballroom"
        studio.locationKey = "4542.0:-12279.0"
        
        studio.defaultInstructor = self.dancerDict["Leilani Nakagawa"]
        studio.instructors = [self.dancerDict["Leilani Nakagawa"]!,self.dancerDict["Joe Broderick"]!,self.dancerDict["Ariel Caplan"]!]

        
        studio = Studio(entity: studioEntity!, insertInto: DVOCoreData.sharedObject.managedObjectContext)
        studio.name = "Old Uptown Ballroom"
        studio.locationKey = "4540.0:-12275.0"
        studio.defaultInstructor = self.dancerDict["Leilani Nakagawa"]
        studio.instructors = [self.dancerDict["Leilani Nakagawa"]!,self.dancerDict["Joe Broderick"]!,self.dancerDict["Ariel Caplan"]!]

        
        studio = Studio(entity: studioEntity!, insertInto: DVOCoreData.sharedObject.managedObjectContext)
        studio.name = "Rose City Swing"
        studio.locationKey = "4557.0:-12258.0"
        
        studio = Studio(entity: studioEntity!, insertInto: DVOCoreData.sharedObject.managedObjectContext)
        studio.name = "Norse Hall"
        studio.locationKey = "4552.0:-12266.0"
        
        studio = Studio(entity: studioEntity!, insertInto: DVOCoreData.sharedObject.managedObjectContext)
        studio.name = "Ballroom Dance Company"
        studio.locationKey = "4543.0:-12277.0"
        studio.defaultInstructor = self.dancerDict["Marcus Sterling"]
        studio.instructors = [self.dancerDict["Marcus Sterling"]!,self.dancerDict["Trina Siebert"]!]

        
        studio = Studio(entity: studioEntity!, insertInto: DVOCoreData.sharedObject.managedObjectContext)
        studio.name = "Clackamas Grange"
        studio.locationKey = "4543.0:-12253.0"
        
        studio = Studio(entity: studioEntity!, insertInto: DVOCoreData.sharedObject.managedObjectContext)
        studio.name = "Home"
        studio.locationKey = "4553.0:-12292.0"
        studio.defaultInstructor = self.dancerDict["Cassie Winter"]
        
        do {
            try DVOCoreData.sharedObject.managedObjectContext.save()
        } catch {
            print ("could not save found studios")
        }
    }

    func populateLocalVideoData() {
        
//        let fetchRequest:NSFetchRequest<Studio> = NSFetchRequest()
//        guard let locationEntity = NSEntityDescription.entity(forEntityName: Studio.entityName, in: DVOCoreData.sharedObject.managedObjectContext) else { return }
//        fetchRequest.entity = locationEntity
//        
//        fetchRequest.fetchBatchSize = 0
//        
//        let sortDescriptor = NSSortDescriptor(key:  StudioAttributes.locationKey, ascending: false)
//        
//        fetchRequest.sortDescriptors = [sortDescriptor]
//        
//        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DVOCoreData.sharedObject.managedObjectContext, sectionNameKeyPath: nil, cacheName: "Master")
//        
//        do {
//            try fetchedResultsController.performFetch()
//            if let studios = fetchedResultsController.fetchedObjects as [Studio]? {
//                
//                for studio in studios {
//                    if let key = studio.locationKey, let address = studio.address {
//                        if DVOCoreData.foundAddresses[key] == nil {
//                            DVOCoreData.foundAddresses[key] = address
//                        } else {
//                            DVOCoreData.sharedObject.managedObjectContext.delete(studio)
//                        }
//                    }
//                }
//            }
//            
//        } catch {
//            abort()
//        }
        
       
        
        
        guard let videoAssetEntity = NSEntityDescription.entity(forEntityName: VideoAssets.entityName, in: DVOCoreData.sharedObject.managedObjectContext) else { return }
        
        let videoAssetFetch:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        videoAssetFetch.entity = videoAssetEntity
        videoAssetFetch.sortDescriptors = [NSSortDescriptor(key: VideoAssetsAttributes.locationKey, ascending: false)]
        let videoAssetFetchResultsController = NSFetchedResultsController(fetchRequest: videoAssetFetch, managedObjectContext: DVOCoreData.sharedObject.managedObjectContext, sectionNameKeyPath: nil, cacheName: "Master")
        var localKeys = [String:Bool]()
        do {
            try videoAssetFetchResultsController.performFetch()
            if let vidoes = videoAssetFetchResultsController.fetchedObjects as? [VideoAssets] {
                for video in vidoes  {
                    if let key = video.localIdentifier {
                        if localKeys[key] == nil  {
                            localKeys[key] = true
                        }
                    }
                }
            }
        } catch {
            abort()
        }
        
        var allCollections = [PHAssetCollection]()
        let collectionFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
        collectionFetchResult.enumerateObjects ({ (collection, index, done) in
            allCollections.append(collection)
        })
        let allVideosOptions = PHFetchOptions()
        allVideosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        allVideosOptions.predicate = NSPredicate(format: "mediaType = \(PHAssetMediaType.video.rawValue) ")
        allVideosOptions.includeAssetSourceTypes = [PHAssetSourceType.typeCloudShared,PHAssetSourceType.typeUserLibrary,PHAssetSourceType.typeiTunesSynced]
        let allVideos = PHAsset.fetchAssets(with: .video, options: allVideosOptions)
        
        allVideos.enumerateObjects({ (asset, index, done) in
            if localKeys[asset.localIdentifier] == nil  {
                let newVideoAsset = VideoAssets(entity: videoAssetEntity, insertInto: DVOCoreData.sharedObject.managedObjectContext)
                newVideoAsset.localIdentifier = asset.localIdentifier
                
                if let thisLocation = asset.location {
                    let locationKey = "\(round(thisLocation.coordinate.latitude*100)):\(round(thisLocation.coordinate.longitude*100))"
                    newVideoAsset.locationKey = locationKey
                    if let foundAddress = DVOCoreData.foundAddresses[locationKey] {
                        newVideoAsset.address = foundAddress
                    } else {
                        let locator = CLGeocoder()
                        locator.reverseGeocodeLocation(thisLocation) { (placemarks, error ) in
                            if let placemark = placemarks?[0]  {
                                if let addressDictionary = placemark.addressDictionary as? [String:AnyObject] {
                                    if let address = addressDictionary["FormattedAddressLines"] as? [String] {
                                        DVOCoreData.foundAddresses["locationKey"] = "\(address[0]), \(address[1])"
                                        newVideoAsset.address = "\(address[0]), \(address[1])"
                                        do {
                                            try DVOCoreData.sharedObject.managedObjectContext.save()
                                        } catch {
                                            print ("could not save found address")
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                if let created = asset.creationDate {
                    newVideoAsset.createdDate = created
                }
            }
        })
    }
    
}

