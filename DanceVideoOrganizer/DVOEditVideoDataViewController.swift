//
//  DVOEditVideoDataViewController.swift
//  DanceVideoOrganizer
//
//  Created by Wayne Ohmer on 5/31/16.
//  Copyright © 2016 Wayne Ohmer. All rights reserved.
//

import UIKit
import AVKit
import Photos

class DVOEditVideoDataViewController: UIViewController, UITabBarDelegate, UITableViewDelegate, UITableViewDataSource {

    var videoAsset = DVOVideoAsset()
    var cellArray: [DVOMetaDataEntryLayout.CellData]!
    var layout: DVOMetaDataEntryLayout!
    @IBOutlet weak var layoutTableView: UITableView!
    @IBOutlet weak var thumbNailImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.thumbNailImageView.image = self.videoAsset.thumbNail
        self.layout = DVOMetaDataEntryLayout(videoAsset: self.videoAsset)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveTouched))

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.cellArray = self.layout.updateCells()
        self.layoutTableView.reloadData()
        self.layoutTableView.tableFooterView = UIView(frame: CGRect.zero)

    }
    
    func saveTouched() {
        
        do {
            try DVOCoreData.sharedObject.managedObjectContext.save()
        } catch {
            print ("could not save metaData")
        }
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
        
    @IBAction func typeChanged(_ sender: UISegmentedControl) {
        self.layout.handleTypeChange(sender.selectedSegmentIndex)
        self.cellArray = self.layout.updateCells()
        self.layoutTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! DVOVideoPlayerViewController
        controller.videoAsset = self.videoAsset.videoAsset!
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
         return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DVOMetaDataEntryCell", for: indexPath) as! DVOMetaDataEntryCell
        cell.descriptionLabel.text = self.cellArray[(indexPath as NSIndexPath).item].description
        cell.dataLabel.text = self.cellArray[(indexPath as NSIndexPath).item].data
        cell.isHidden = !self.cellArray[(indexPath as NSIndexPath).item].visible
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.cellArray[indexPath.item].destination?(self.navigationController)
    }

}
