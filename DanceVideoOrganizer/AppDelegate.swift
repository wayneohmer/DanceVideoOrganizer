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

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        self.populateLocalVideoData()
        self.populateStudioData()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        DVOCoreData.sharedObject.saveContext()
    }
    
    func populateStudioData() {
        
        let fetchedResultsController = DVOCoreData.fetchStudios()
        
        do {
            try fetchedResultsController.performFetch()
            if let studios = fetchedResultsController.fetchedObjects as? [Studio] {
                for studio in studios {
                    if let key = studio.valueForKey("locationKey") as? String {
                        switch key {
                        case "4744.0:-12229.0":
                            studio.name = "Sea To Sky"
                        case "4562.0:-12267.0":
                            studio.name = "Bridge Town"
                        case "4542.0:-12279.0":
                            studio.name = "Uptown Ballroom"
                            let dancerEntity = NSEntityDescription.entityForName(Dancer.entityName, inManagedObjectContext: DVOCoreData.sharedObject.managedObjectContext)
                            let newDancer = Dancer(entity: dancerEntity!, insertIntoManagedObjectContext: DVOCoreData.sharedObject.managedObjectContext)
                            newDancer.name = "Leilani Nakagawa"
                            newDancer.defaultStudio = studio
                            newDancer.studio = [studio]
                            studio.defaultInstructor = newDancer
                            studio.instructors = [newDancer]
                        case "4540.0:-12275.0":
                            studio.name = "Old Uptown Ballroom"
                        case "4557.0:-12258.0":
                            studio.name = "Rose City Swing"
                        case "4552.0:-12266.0":
                            studio.name = "Norse Hall"
                        case "4543.0:-12277.0":
                            studio.name = "Ballroom Dance Company"
                        case "4543.0:-12253.0":
                            studio.name = "Clackamas Grange"
                        case "4553.0:-12292.0":
                            studio.name = "Home"
                            
                        default: break
                        }
                    }
                }
            }
            do {
                try DVOCoreData.sharedObject.managedObjectContext.save()
            } catch {
                print ("could not save found address")
            }
        } catch {
            abort()
        }

    }

    func populateLocalVideoData() {
        
        let fetchRequest = NSFetchRequest()
        guard let locationEntity = NSEntityDescription.entityForName(Studio.entityName, inManagedObjectContext: DVOCoreData.sharedObject.managedObjectContext) else { return }
        fetchRequest.entity = locationEntity
        
        fetchRequest.fetchBatchSize = 0
        
        let sortDescriptor = NSSortDescriptor(key:  StudioAttributes.locationKey, ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DVOCoreData.sharedObject.managedObjectContext, sectionNameKeyPath: nil, cacheName: "Master")
        
        do {
            try fetchedResultsController.performFetch()
            if let studios = fetchedResultsController.fetchedObjects as? [Studio] {
                
                for studio in studios {
                    if let key = studio.locationKey, let address = studio.address {
                        if DVOCoreData.foundAddresses[key] == nil {
                            DVOCoreData.foundAddresses[key] = address
                        } else {
                            DVOCoreData.sharedObject.managedObjectContext.deleteObject(studio)
                        }
                    }
                }
            }
            
        } catch {
            abort()
        }
        guard let videoAssetEntity = NSEntityDescription.entityForName(VideoAssets.entityName, inManagedObjectContext: DVOCoreData.sharedObject.managedObjectContext) else { return }
        
        let videoAssetFetch = NSFetchRequest()
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
        
        let allVideosOptions = PHFetchOptions()
        allVideosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        allVideosOptions.predicate = NSPredicate(format: "mediaType = \(PHAssetMediaType.Video.rawValue) ")
        let allVideos = PHAsset.fetchAssetsWithOptions(allVideosOptions)
        
        allVideos.enumerateObjectsUsingBlock() { (asset, index, done) in
            if let thisAsset = asset as? PHAsset {
                if localKeys[thisAsset.localIdentifier] == nil  {
                    let newVideoAsset = VideoAssets(entity: videoAssetEntity, insertIntoManagedObjectContext: DVOCoreData.sharedObject.managedObjectContext)
                    newVideoAsset.localIdentifier = thisAsset.localIdentifier
                    if let thisLocation = thisAsset.location {
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
                                            let newStudio = Studio(entity: locationEntity, insertIntoManagedObjectContext: DVOCoreData.sharedObject.managedObjectContext)
                                            newStudio.address = "\(address[0]), \(address[1])"
                                            newStudio.locationKey = locationKey
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
                    if let created = thisAsset.creationDate {
                        newVideoAsset.createdDate = created
                    }
                }
            }
        }
    }

}

