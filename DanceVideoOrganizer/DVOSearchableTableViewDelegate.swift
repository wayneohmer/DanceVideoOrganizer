//
//  DVOSearchableTableView.swift
//  DanceVideoOrganizer
//
//  Created by Wayne Ohmer on 6/17/16.
//  Copyright © 2016 Wayne Ohmer. All rights reserved.
//

import UIKit

class DVOSearchableTableViewDelegate: NSObject, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {

    var cellArray = [SearchableName]()
    var filteredArray = [SearchableName]()
    var selectedDict = [String:SearchableName]()
    let searchController = UISearchController(searchResultsController: nil)
    var tableView: UITableView?
    var allowMultipleSelection = true

    override init() {
        super.init()
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = false
    }
    
    convenience init(tableView: UITableView, showSearchBar:Bool) {
        self.init()
        self.tableView = tableView
        if showSearchBar {
            self.tableView?.tableHeaderView = searchController.searchBar
        }
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
    }
    
    func update() {
        self.filteredArray = self.cellArray
        self.tableView?.reloadData()
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        if searchText != "" {
            self.filteredArray = self.cellArray.filter { cellObject in
                
                return cellObject.searchableName.lowercaseString.containsString(searchText.lowercaseString)
            }
        } else {
            self.filteredArray = self.cellArray
        }
        self.tableView?.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = self.filteredArray[indexPath.item].searchableName
        if selectedDict[self.filteredArray[indexPath.item].searchableName] != nil {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = .Checkmark
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if self.selectedDict[self.filteredArray[indexPath.item].searchableName] == nil {
            if !allowMultipleSelection {
                self.selectedDict.removeAll()
            }
            self.selectedDict[self.filteredArray[indexPath.item].searchableName] = self.filteredArray[indexPath.item]
        } else {
            self.selectedDict[self.filteredArray[indexPath.item].searchableName] = nil
        }
        tableView.reloadData()
        self.searchController.active = false
        NSNotificationCenter.defaultCenter().postNotificationName("searchableTalbleViewChanged" , object:nil, userInfo:nil)
        
    }
    
}
