//
//  DVOLocationTableViewController.swift
//  DanceVideoOrganizer
//
//  Created by Wayne Ohmer on 6/3/16.
//  Copyright © 2016 Wayne Ohmer. All rights reserved.
//

import UIKit

class DVOLocationTableViewController: UITableViewController, UISearchResultsUpdating {
    
    var metaData: VideoMetaData!
    var locationArray = [[SearchableName](),[SearchableName]()]
    var filteredArray = [SearchableName]()
    var selectedName = ""
    var selectedLocation: SearchableName?
    let searchController = UISearchController(searchResultsController: nil)
    let mainStoryboard = UIStoryboard(name:"Main", bundle: nil)
    @IBOutlet var locationTypeSegmentedControl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedName = self.metaData.location
        let eventFetchController = DVOCoreData.fetchEvents()
        do {
            try eventFetchController.performFetch()
            if let events = eventFetchController.fetchedObjects as? [Event] {
                for event in events {
                    if event.name != nil && event.name != "" {
                        self.locationArray[0].append(event)
                        if let selectedName = self.selectedLocation?.searchableName {
                            if event.name == selectedName {
                                self.selectedName = selectedName
                            }
                        }
                    }
                }
            }
        } catch {
            print("failed to fetch Studios")
        }

        let studioFetchController = DVOCoreData.fetchStudios()
        do {
            try studioFetchController.performFetch()
            if let studios = studioFetchController.fetchedObjects as? [Studio] {
                for studio in studios {
                    if studio.name != nil && studio.name != "" {
                        self.locationArray[1].append(studio)
                        if let selectedName = self.selectedLocation?.searchableName {
                            if studio.name == selectedName {
                                self.selectedName = selectedName
                            }
                        }
                    }
                }
            }
        } catch {
            print("failed to fetch Studios")
        }
        self.navigationItem.titleView = self.locationTypeSegmentedControl
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        self.tableView.tableHeaderView = searchController.searchBar
        self.filteredArray = self.locationArray[self.locationTypeSegmentedControl.selectedSegmentIndex]
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addButtonTouched))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func locationTypeChanged() {
        self.filteredArray = self.locationArray[self.locationTypeSegmentedControl.selectedSegmentIndex]
        self.tableView.reloadData()
    }

    func addButtonTouched() {
        let vc = self.mainStoryboard.instantiateViewControllerWithIdentifier("DVOLocationEditViewController") as! DVOLocationEditViewController
        vc.metaData = self.metaData
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        if searchText != "" {
            self.filteredArray =  self.locationArray[self.locationTypeSegmentedControl.selectedSegmentIndex].filter { location in
                return location.searchableName.lowercaseString.containsString(searchText.lowercaseString)
            }
        } else {
            self.filteredArray = self.locationArray[self.locationTypeSegmentedControl.selectedSegmentIndex]
        }
        self.tableView.reloadData()
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        self.filterContentForSearchText(searchController.searchBar.text!)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = self.filteredArray[indexPath.item].searchableName
        if self.selectedName == cell.textLabel?.text {
            cell.accessoryType = .Checkmark
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = self.tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = .Checkmark
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if self.filteredArray[indexPath.item] is Studio {
            self.metaData.studio = self.filteredArray[indexPath.item] as? Studio
        } else if self.filteredArray[indexPath.item] is Event {
            self.metaData.event = self.filteredArray[indexPath.item] as? Event
        }
        self.navigationController?.popViewControllerAnimated(true)
       
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
