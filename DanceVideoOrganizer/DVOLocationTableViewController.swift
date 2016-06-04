//
//  DVOLocationTableViewController.swift
//  DanceVideoOrganizer
//
//  Created by Wayne Ohmer on 6/3/16.
//  Copyright © 2016 Wayne Ohmer. All rights reserved.
//

import UIKit

class DVOLocationTableViewController: UITableViewController, UISearchResultsUpdating {
    
    var metaData:VideoMetaData!
    var studioArray = [Studio]()
    var filteredArray = [Studio]()
    var selectedIndex = NSIndexPath(forRow: 0, inSection: 0)
    var selectedStudio:Studio?
    let searchController = UISearchController(searchResultsController: nil)

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let studioFetchController = DVOCoreData.fetchStudios()
        do {
            try studioFetchController.performFetch()
            if let studios = studioFetchController.fetchedObjects as? [Studio] {
                var idx = 0
                for studio in studios {
                    if studio.name != nil && studio.name != "" {
                        self.studioArray.append(studio)
                        if let selectedName = self.selectedStudio?.name {
                            if studio.name == selectedName {
                                self.selectedIndex = NSIndexPath(forRow: idx, inSection: 0)
                            }
                        }
                        idx += 1
                    }
                }
            }
        } catch {
            print("failed to fetch Studios")
        }
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        self.tableView.tableHeaderView = searchController.searchBar
        self.filteredArray = self.studioArray
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func filterContentForSearchText(searchText: String, scope: String = "All") {
        if searchText != "" {
            self.filteredArray = studioArray.filter { studio in
                if studio.name!.lowercaseString.containsString(searchText.lowercaseString) {
                    print(studio.name!.lowercaseString,searchText.lowercaseString)
                }
                return studio.name!.lowercaseString.containsString(searchText.lowercaseString)
            }
        } else {
            self.filteredArray = self.studioArray
        }
        tableView.reloadData()
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        self.filterContentForSearchText(searchController.searchBar.text!)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.filteredArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = self.filteredArray[indexPath.item].name
        if selectedStudio != nil && self.selectedIndex.item == indexPath.item {
            cell.accessoryType = .Checkmark
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell = self.tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = .Checkmark
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.metaData.studio = self.filteredArray[indexPath.item]
        self.navigationController?.popViewControllerAnimated(true)
        if indexPath.item != selectedIndex.item {
            cell = self.tableView.cellForRowAtIndexPath(self.selectedIndex)
            cell?.accessoryType = .None
            self.selectedIndex = indexPath
        }
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
