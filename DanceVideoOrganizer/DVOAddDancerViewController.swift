//
//  DVOAddDancerViewController.swift
//  DanceVideoOrganizer
//
//  Created by Wayne Ohmer on 10/14/16.
//  Copyright © 2016 Wayne Ohmer. All rights reserved.
//

import UIKit
import CoreData

class DVOAddDancerViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveTouched(_ sender: UIBarButtonItem) {
        
        let dancer = Dancer(entity: NSEntityDescription.entity(forEntityName: Dancer.entityName, in: DVOCoreData.sharedObject.managedObjectContext)!, insertInto: DVOCoreData.sharedObject.managedObjectContext)
        dancer.name = self.nameField.text
        do {
            try DVOCoreData.sharedObject.managedObjectContext.save()
        } catch {
            print ("could not save Dancer")
        }
        _ = self.navigationController?.popViewController(animated: true)
    }


}
