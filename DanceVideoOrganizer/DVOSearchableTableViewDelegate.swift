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
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        if searchText != "" {
            self.filteredArray = self.cellArray.filter { cellObject in
                
                return cellObject.searchableName.lowercased().contains(searchText.lowercased())
            }
        } else {
            self.filteredArray = self.cellArray
        }
        self.tableView?.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = self.filteredArray[(indexPath as NSIndexPath).item].searchableName
        if selectedDict[self.filteredArray[(indexPath as NSIndexPath).item].searchableName] != nil {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        tableView.deselectRow(at: indexPath, animated: true)
        if self.selectedDict[self.filteredArray[(indexPath as NSIndexPath).item].searchableName] == nil {
            if !allowMultipleSelection {
                self.selectedDict.removeAll()
            }
            self.selectedDict[self.filteredArray[(indexPath as NSIndexPath).item].searchableName] = self.filteredArray[(indexPath as NSIndexPath).item]
        } else {
            self.selectedDict[self.filteredArray[(indexPath as NSIndexPath).item].searchableName] = nil
        }
        tableView.reloadData()
        self.searchController.isActive = false
        NotificationCenter.default.post(name: Notification.Name(rawValue: "searchableTalbleViewChanged") , object:nil, userInfo:nil)
        
    }
    
}
