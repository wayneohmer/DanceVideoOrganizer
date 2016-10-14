//
//  DVOMetaDataTitleViewController.swift
//  DanceVideoOrganizer
//
//  Created by Wayne Ohmer on 6/3/16.
//  Copyright © 2016 Wayne Ohmer. All rights reserved.
//

import UIKit

class DVOMetaDataTitleViewController: UIViewController {

    @IBOutlet weak var titleField: DVOTextField!
    var metaData:VideoMetaData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleField.text = self.metaData.title
        self.titleField.addInputAccessoryBarWithTitle(self.titleField.title ?? "")
        self.titleField.didEndDidEndEditingClosure = { (textField: UITextField) in
            self.metaData.title = textField.text
            _ = self.navigationController?.popViewController(animated: true)
        }
        self.titleField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
