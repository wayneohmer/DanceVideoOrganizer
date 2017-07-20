//
//  DVODancerTableViewController.swift
//  DanceVideoOrganizer
//
//  Created by Wayne Ohmer on 6/5/16.
//  Copyright © 2016 Wayne Ohmer. All rights reserved.
//

import UIKit

class DVODancerTableViewController: UITableViewController, UISearchResultsUpdating, UINavigationControllerDelegate {

    var metaData: VideoMetaData!
    var nameArray = [Dancer]()
    var filteredArray = [Dancer]()
    var selectedDancers: [String:Dancer]?
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        self.tableView.tableHeaderView = searchController.searchBar
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.navigationController?.delegate = self

    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        self.nameArray.removeAll()
        let dancerFetchController = DVOCoreData.fetchDancers()
        do {
            try dancerFetchController.performFetch()
            if let objects = dancerFetchController.fetchedObjects as [Dancer]? {
                for data in objects {
                    if data.name != nil && data.name != "" {
                        self.nameArray.append(data)
                    }
                }
            }
        } catch {
            print("failed to fetch Dancers")
        }
        self.filteredArray = self.nameArray
        self.tableView.reloadData()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func saveTouched() {
        if let dancers = self.selectedDancers {
            self.metaData.instructors?.removeAll()
            for (_,dancer) in dancers {
                // this should be insert(dancer) but it gives nonsensical error.
                self.metaData.instructors = self.metaData.instructors?.union(Set([dancer]))
            }
        }
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addTouched() {
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        if searchText != "" {
            self.filteredArray = self.nameArray.filter { studio in
                
                return studio.name!.lowercased().contains(searchText.lowercased())
            }
        } else {
            self.filteredArray = self.nameArray
        }
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        self.filterContentForSearchText(searchController.searchBar.text!)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = self.filteredArray[(indexPath as NSIndexPath).item].name
        if selectedDancers?[self.filteredArray[(indexPath as NSIndexPath).item].name!] != nil {
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        self.tableView.deselectRow(at: indexPath, animated: true)
        if self.selectedDancers![self.filteredArray[indexPath.item].name!] == nil {
            self.selectedDancers![self.filteredArray[indexPath.item].name!] = self.filteredArray[indexPath.item]
        } else {
            self.selectedDancers![self.filteredArray[(indexPath).item].name!] = nil
            self.tableView.reloadData()
        }
        self.searchController.isActive = false

    }

}
