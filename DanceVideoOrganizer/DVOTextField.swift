//
//  BTTextField.swift
//  BonziTeam
//
//  Created by Wayne Ohmer on 2/5/16.
//
//

import UIKit

class DVOTextField: UITextField, UITextFieldDelegate
{

    // properties for overiding delegate functions.
    var shouldReturnClosure:((textField: UITextField) -> Bool)? = nil
    var shouldChangeCharactersInRangeClosure:((textField: UITextField, range: NSRange, replacementString: String) -> Bool)? = nil
    var didEndDidEndEditingClosure:((textField: UITextField) -> ())? = nil
    
    @IBInspectable var title:String?
    @IBInspectable var maxLength:Int = 0
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.CGColor
        }
    }

    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self
    }
    //Override textRects to pad left margin. Without this, text is smashed against the left border. This matches the default for textFields.
    override func textRectForBounds(bounds: CGRect) -> CGRect
    {
        return UIEdgeInsetsInsetRect(bounds,UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5))
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect
    {
        return self.textRectForBounds(bounds);
    }
    
    func addInputAccessoryBarWithTitle(title:String)
    {
        if let bar = DVOInputAccessoryBar.newAccessoryBarWithTitle(title,textField:self) {
            self.inputAccessoryView = bar
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        var returnValue = true
        if (range.length + range.location > textField.text!.characters.count ) {
            returnValue = false
        }
        if self.maxLength > 0 {
            let newLength:Int = textField.text!.characters.count + string.characters.count - range.length
            returnValue = newLength <= self.maxLength
        } else {
            returnValue = true
        }
        if shouldChangeCharactersInRangeClosure != nil {
            return returnValue && self.shouldChangeCharactersInRangeClosure!(textField: textField,range: range, replacementString: string)
            
        } else {
            return returnValue
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField)
    {
        self.didEndDidEndEditingClosure?(textField: textField)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if self.shouldReturnClosure != nil {
            return (self.shouldReturnClosure?(textField: textField))!
        } else {
            return true
        }
    }

}
