//
//  DVOCompEditViewController.swift
//  DanceVideoOrganizer
//
//  Created by Wayne Ohmer on 6/17/16.
//  Copyright © 2016 Wayne Ohmer. All rights reserved.
//

import UIKit

class DVOCompEditViewController: UIViewController {

    @IBOutlet weak var compLevelTableView: UITableView!
    @IBOutlet weak var compTypeTableView: UITableView!
    @IBOutlet weak var compRoundTableVlew: UITableView!
    @IBOutlet weak var selectedLabel: UILabel!
    
    var compLevelObject: DVOSearchableTableViewDelegate!
    var compTypeObject: DVOSearchableTableViewDelegate!
    var compRoundObject: DVOSearchableTableViewDelegate!
    
    var metaData: VideoMetaData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: #selector(saveButtonTouched))

        self.compLevelObject = DVOSearchableTableViewDelegate(tableView: compLevelTableView, showSearchBar: false)
        if let complevels = self.metaData.compLevel {
            for compLevel in complevels {
                self.compLevelObject.selectedDict[compLevel.searchableName] = compLevel
            }
        }
        
        self.compTypeObject = DVOSearchableTableViewDelegate(tableView: compTypeTableView, showSearchBar: false)
        if let comptype = self.metaData.compType {
            self.compTypeObject.selectedDict[comptype.searchableName] = comptype
        }
        self.compTypeObject.allowMultipleSelection = false

        self.compRoundObject = DVOSearchableTableViewDelegate(tableView: compRoundTableVlew, showSearchBar: false)
        if let compRound = self.metaData.compRound {
            self.compRoundObject.selectedDict[compRound.searchableName] = compRound
        }
        self.compRoundObject.allowMultipleSelection = false
        
        definesPresentationContext = true
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(tableViewChanged), name: "searchableTalbleViewChanged", object: nil)
        let levelFetchController = DVOCoreData.fetchCompLevels()
        do {
            try levelFetchController.performFetch()
            if let compLevels = levelFetchController.fetchedObjects as? [CompLevel] {
                for complevel in compLevels {
                    if complevel.levelDesc != nil  {
                        self.compLevelObject.cellArray.append(complevel)
                    }
                }
            }
        } catch {
            print("failed to fetch CompLevels")
        }
        
        let typeFetchController = DVOCoreData.fetchCompTypes()
        do {
            try typeFetchController.performFetch()
            if let compTypes = typeFetchController.fetchedObjects as? [CompType] {
                for compType in compTypes {
                    if compType.typeDesc != nil  {
                        self.compTypeObject.cellArray.append(compType)
                    }
                }
            }
        } catch {
            print("failed to fetch CompLevels")
        }
        
        let roundFetchController = DVOCoreData.fetchCompRounds()
        do {
            try roundFetchController.performFetch()
            if let compRounds = roundFetchController.fetchedObjects as? [CompRound] {
                for compRound in compRounds {
                    if compRound.roundDesc != nil  {
                        self.compRoundObject.cellArray.append(compRound)
                    }
                }
            }
        } catch {
            print("failed to fetch CompLevels")
        }
        self.compLevelObject.update()
        self.compTypeObject.update()
        self.compRoundObject.update()
        // Do any additional setup after loading the view.
    }

    func tableViewChanged() {
        self.selectedLabel.text = ""
        var levelsArray = [String]()
        for (key,_) in compLevelObject.selectedDict {
            levelsArray.append(key)
        }
        self.selectedLabel.text = "\(levelsArray.joinWithSeparator("/"))"
        for (key,_) in compTypeObject.selectedDict {
            self.selectedLabel.text = "\(self.selectedLabel.text!) \(key)"
        }
        for (key,_) in compRoundObject.selectedDict {
            self.selectedLabel.text = "\(self.selectedLabel.text!) \(key)"
        }
    }

    func saveButtonTouched() {
        
        self.metaData.compLevel?.removeAll()
        for (_,level) in compLevelObject.selectedDict {
            self.metaData.compLevel?.insert((level as? CompLevel)!)
        }
        for (_,type) in compTypeObject.selectedDict {
            self.metaData.compType = type as? CompType
        }
        for (_,round) in compRoundObject.selectedDict {
            self.metaData.compRound = round as? CompRound
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
