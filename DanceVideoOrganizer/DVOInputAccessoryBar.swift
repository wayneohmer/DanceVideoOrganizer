//
//  DVOInputAccessoryBar.swift
//  BonziTeam
//
//  Created by Wayne Ohmer on 9/18/15.
//

import UIKit

class DVOInputAccessoryBar: UINavigationBar
{
    
    @IBOutlet weak var titleItem: UINavigationItem!
    var savedText:String? = ""

    var textField:UITextField? {
        didSet {
            self.savedText = textField?.text
        }
    }
    
    var textView:UITextView? {
        didSet {
            self.savedText = self.textView?.text
        }
    }

    class func newAccessoryBar() -> DVOInputAccessoryBar?
    {
        
        if let returnBar = NSBundle.mainBundle().loadNibNamed("DVOInputAccessoryBar", owner: self, options: nil)[0] as? DVOInputAccessoryBar {
            return returnBar
        }
        
        return nil
    }
    
    class func newAccessoryBarWithTitle(title:String) -> DVOInputAccessoryBar?
    {
        if let returnBar = self.newAccessoryBar() {
            returnBar.titleItem.title = title
            return returnBar
        }
        
        return nil
    }
    
    class func newAccessoryBarWithTitle(title:String,textField:UITextField) -> DVOInputAccessoryBar?
    {
        if let returnBar = self.newAccessoryBarWithTitle(title) {
            returnBar.textField = textField
            textField.inputAccessoryView = returnBar
            return returnBar
        }
        
        return nil
    }
    
    override func awakeFromNib()
    {
        //self.barTintColor = BTGlobals.customColors[BTColorKeys.bonziLightGrey]
        self.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.blackColor()]
       // self.tintColor = BTGlobals.customColors[BTColorKeys.bonziCharcoal]
        self.barStyle = .Default
    }
    
    @IBAction func cancelButtonTouch(sender: UIBarButtonItem)
    {
        if self.textField != nil {
            self.textField?.text = self.savedText
            self.textField?.resignFirstResponder()
        } else if self.textView != nil {
            self.textView?.text = self.savedText
            self.textView?.resignFirstResponder()
        }
    }

    @IBAction func applyButtonTouch(sender: UIBarButtonItem)
    {
        if self.textField != nil {
            self.savedText = self.textField!.text
            self.textField?.resignFirstResponder()
        } else if self.textView != nil {
            self.savedText = self.textView!.text
            self.textView?.resignFirstResponder()
        }
    }
}