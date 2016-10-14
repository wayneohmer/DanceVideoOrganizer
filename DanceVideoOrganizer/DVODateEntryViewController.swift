//
//  DVODateEntryViewController.swift
//  DanceVideoOrganizer
//
//  Created by Wayne Ohmer on 6/6/16.
//  Copyright © 2016 Wayne Ohmer. All rights reserved.
//

import UIKit

class DVODateEntryViewController: UIViewController {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var metaData: VideoMetaData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveTouched))
        self.dateLabel.text = DVODateFormatter.formattedDate(self.metaData.date)
        self.datePicker.date = self.metaData.date as Date? ?? Date()
        
        // Do any additional setup after loading the view.
    }
    
    func saveTouched() {
        self.metaData.date = self.datePicker.date
        _ = self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        self.dateLabel.text = DVODateFormatter.formattedDate(sender.date)
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
