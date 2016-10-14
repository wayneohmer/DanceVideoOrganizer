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
            if let events = eventFetchController.fetchedObjects as [Event]? {
                for event in events {
                    if event.name != nil && event.name != "" {
                        self.locationArray[1].append(event)
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
            if let studios = studioFetchController.fetchedObjects as [Studio]? {
                for studio in studios {
                    if studio.name != nil && studio.name != "" {
                        self.locationArray[0].append(studio)
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTouched))
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
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
        let vc = self.mainStoryboard.instantiateViewController(withIdentifier: "DVOLocationEditViewController") as! DVOLocationEditViewController
        vc.metaData = self.metaData
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        if searchText != "" {
            self.filteredArray =  self.locationArray[self.locationTypeSegmentedControl.selectedSegmentIndex].filter { location in
                return location.searchableName.lowercased().contains(searchText.lowercased())
            }
        } else {
            self.filteredArray = self.locationArray[self.locationTypeSegmentedControl.selectedSegmentIndex]
        }
        self.tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        self.filterContentForSearchText(searchText: searchController.searchBar.text!)
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
        cell.textLabel?.text = self.filteredArray[(indexPath as NSIndexPath).item].searchableName
        if self.selectedName == cell.textLabel?.text {
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        self.tableView.deselectRow(at: indexPath, animated: true)
        if self.filteredArray[(indexPath as NSIndexPath).item] is Studio {
            self.metaData.studio = self.filteredArray[(indexPath as NSIndexPath).item] as? Studio
        } else if self.filteredArray[(indexPath as NSIndexPath).item] is Event {
            self.metaData.event = self.filteredArray[(indexPath as NSIndexPath).item] as? Event
        }
        _ = self.navigationController?.popViewController(animated: true)
       
    }

}
