//
//  DVOLocationEditViewController.swift
//  DanceVideoOrganizer
//
//  Created by Wayne Ohmer on 6/15/16.
//  Copyright © 2016 Wayne Ohmer. All rights reserved.
//

import UIKit
import CoreData

class DVOLocationEditViewController: UIViewController {

    var metaData: VideoMetaData!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var startDateStackView: UIStackView!
    @IBOutlet weak var endDateStackView: UIStackView!
    @IBOutlet weak var bigStackView: UIStackView!
    @IBOutlet var locationTypeSegmentedControler: UISegmentedControl!
    
    var startDate = Date()
    var endDate = Date()
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addressTextField.text = self.metaData.asset?.address
        self.formatter.dateFormat = "EEEE MM-dd-yyyy"
        self.startDate = self.metaData.date as Date? ?? Date()
        self.endDate = self.metaData.date as Date? ?? Date()
        self.startDateLabel.text = self.formatter.string(from: self.startDate)
        self.endDateLabel.text = self.formatter.string(from: self.endDate)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTouched))
        self.navigationItem.titleView = self.locationTypeSegmentedControler

    }
    
    @IBAction func LocationTypeChanged(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            self.bigStackView.addArrangedSubview(self.startDateStackView)
            self.bigStackView.addArrangedSubview(self.endDateStackView)
        } else {
            self.bigStackView.removeArrangedSubview(self.startDateStackView)
            self.bigStackView.removeArrangedSubview(self.endDateStackView)
        }
    }
    
    func saveButtonTouched() {
        let event = Event(entity: NSEntityDescription.entity(forEntityName: Event.entityName, in: DVOCoreData.sharedObject.managedObjectContext)!, insertInto: DVOCoreData.sharedObject.managedObjectContext)
        event.name = self.nameTextField.text
        event.locationKey = self.metaData.asset?.locationKey
        event.startDate = self.startDate
        event.endDate = self.endDate
        do {
            try DVOCoreData.sharedObject.managedObjectContext.save()
        } catch {
            print ("could not save location")
        }
        _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func dateChangeTouched(_ sender: UIButton) {
        
        switch sender.accessibilityIdentifier! {
        case "startPlus":
            self.startDate = self.startDate.addingTimeInterval(86400)
        case "startMinus":
            self.startDate = self.startDate.addingTimeInterval(-86400)
        case "endPlus":
            self.endDate = self.endDate.addingTimeInterval(86400)
        case "endMinus":
            self.endDate = self.endDate.addingTimeInterval(-86400)
        default:
            break
        }
        self.startDateLabel.text = self.formatter.string(from: self.startDate)
        self.endDateLabel.text = self.formatter.string(from: self.endDate)
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
