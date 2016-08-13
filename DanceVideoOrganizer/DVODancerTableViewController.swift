//
//  DVODancerTableViewController.swift
//  DanceVideoOrganizer
//
//  Created by Wayne Ohmer on 6/5/16.
//  Copyright © 2016 Wayne Ohmer. All rights reserved.
//

import UIKit

class DVODancerTableViewController: UITableViewController, UISearchResultsUpdating {

    var metaData: VideoMetaData!
    var nameArray = [Dancer]()
    var filteredArray = [Dancer]()
    var selectedDancers: [String:Dancer]?
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        let dancerFetchController = DVOCoreData.fetchDancers()
        do {
            try dancerFetchController.performFetch()
            if let objects = dancerFetchController.fetchedObjects as? [Dancer] {
                for data in objects {
                    if data.name != nil && data.name != "" {
                        self.nameArray.append(data)
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
        self.filteredArray = self.nameArray

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: #selector(saveTouched))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func saveTouched() {
        if let dancers = self.selectedDancers {
            self.metaData.instructors?.removeAll()
            for (_,dancer) in dancers {
                // this should be insert(dancer) but it gives nonsensical error.
                self.metaData.instructors = self.metaData.instructors?.union(Set([dancer]))
            }
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        if searchText != "" {
            self.filteredArray = self.nameArray.filter { studio in
                
                return studio.name!.lowercaseString.containsString(searchText.lowercaseString)
            }
        } else {
            self.filteredArray = self.nameArray
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
        return self.filteredArray.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = self.filteredArray[indexPath.item].name
        if selectedDancers?[self.filteredArray[indexPath.item].name!] != nil {
            cell.accessoryType = .Checkmark
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = self.tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = .Checkmark
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if self.selectedDancers![self.filteredArray[indexPath.item].name!] == nil {
            self.selectedDancers![self.filteredArray[indexPath.item].name!] = self.filteredArray[indexPath.item]
        } else {
            self.selectedDancers![self.filteredArray[indexPath.item].name!] = nil
            self.tableView.reloadData()
        }
        
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
