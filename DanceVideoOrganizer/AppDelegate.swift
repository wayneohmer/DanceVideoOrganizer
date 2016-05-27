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
        let fetchRequest = NSFetchRequest()

        let locationEntity = NSEntityDescription.entityForName("Studio", inManagedObjectContext: DVOCoreData.sharedObject.managedObjectContext)
        fetchRequest.entity = locationEntity
        
        fetchRequest.fetchBatchSize = 0
        
        let sortDescriptor = NSSortDescriptor(key: "locationKey", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DVOCoreData.sharedObject.managedObjectContext, sectionNameKeyPath: nil, cacheName: "Master")
        
        do {
            try fetchedResultsController.performFetch()
            for studio in fetchedResultsController.fetchedObjects! as! [NSManagedObject] {
                if let key = studio.valueForKey("locationKey") as? String{
                    switch key{
                    case "4744.0:4744.0":
                        studio.setValue("Sea To Sky", forKey: "name")
                    case "4562.0:4562.0":
                        studio.setValue("Bridge Town", forKey: "name")
                    case "4542.0:4542.0":
                        studio.setValue("Uptown Ballroom", forKey: "name")
                    case "4540.0:4540.0":
                        studio.setValue("Old Uptown Ballroom", forKey: "name")
                    case "4557.0:4557.0":
                        studio.setValue("Rose City Swing", forKey: "name")
                        
                    default: break
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
        let locationEntity = NSEntityDescription.entityForName("Studio", inManagedObjectContext: DVOCoreData.sharedObject.managedObjectContext)
        fetchRequest.entity = locationEntity
        
        fetchRequest.fetchBatchSize = 0
        
        let sortDescriptor = NSSortDescriptor(key: "locationKey", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DVOCoreData.sharedObject.managedObjectContext, sectionNameKeyPath: nil, cacheName: "Master")
        
        do {
            try fetchedResultsController.performFetch()
            for location in fetchedResultsController.fetchedObjects!  {
                if let key = location.valueForKey("locationKey") as? String, let address = location.valueForKey("address") as? String {
                    if DVOCoreData.foundAddresses[key] == nil {
                        DVOCoreData.foundAddresses[key] = address
                        print("\(key) \(address)")
                    } else {
                        DVOCoreData.sharedObject.managedObjectContext.deleteObject(location as! NSManagedObject)
                    }
                }
            }
            
        } catch {
            abort()
        }
        let videoAssetEntity = NSEntityDescription.entityForName("VideoAssets", inManagedObjectContext: DVOCoreData.sharedObject.managedObjectContext)
        
        let videoAssetFetch = NSFetchRequest()
        videoAssetFetch.entity = videoAssetEntity
        videoAssetFetch.sortDescriptors = [NSSortDescriptor(key: "locationKey", ascending: false)]
        let videoAssetFetchResultsController = NSFetchedResultsController(fetchRequest: videoAssetFetch, managedObjectContext: DVOCoreData.sharedObject.managedObjectContext, sectionNameKeyPath: nil, cacheName: "Master")
        var localKeys = [String:Bool]()
        do {
            try videoAssetFetchResultsController.performFetch()
            for video in videoAssetFetchResultsController.fetchedObjects!  {
                if let key = video.valueForKey("localIdentifier") as? String {
                    if localKeys[key] == nil {
                        localKeys[key] = true
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
                if localKeys[thisAsset.localIdentifier] == nil {
                    let thisVideo = VideoAsset()
                    thisVideo.asset = thisAsset
                    let newVideoAsset = NSManagedObject(entity: videoAssetEntity!, insertIntoManagedObjectContext: DVOCoreData.sharedObject.managedObjectContext)
                    newVideoAsset.setValue(thisAsset.localIdentifier, forKey: "localIdentifier")
                    if let thisLocation = thisAsset.location {
                        let locationKey = "\(round(thisLocation.coordinate.latitude*100)):\(round(thisLocation.coordinate.latitude*100))"
                        newVideoAsset.setValue(locationKey, forKey: "LocationKey")
                        if let foundAddress = DVOCoreData.foundAddresses[locationKey] {
                            thisVideo.address = foundAddress
                        } else {
                            let locator = CLGeocoder()
                            locator.reverseGeocodeLocation(thisLocation) { (placemarks, error ) in
                                if let placemark = placemarks?[0]  {
                                    if let addressDictionary = placemark.addressDictionary as? [String:AnyObject] {
                                        if let address = addressDictionary["FormattedAddressLines"] as? [String] {
                                            DVOCoreData.foundAddresses["locationKey"] = "\(address[0]), \(address[1])"
                                            thisVideo.address = "\(address[0]), \(address[1])"
                                            let newEntity = NSManagedObject(entity: locationEntity!, insertIntoManagedObjectContext: DVOCoreData.sharedObject.managedObjectContext)
                                            newEntity.setValue("\(address[0]), \(address[1])", forKey: "address")
                                            newEntity.setValue(locationKey, forKey: "locationKey")
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
                        newVideoAsset.setValue(created, forKey: "createdDate")
                    }
                }
            }
        }
    }

}

