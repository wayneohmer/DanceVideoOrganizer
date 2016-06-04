//
//  DVODateFormatter.swift
//  DanceVideoOrganizer
//
//  Created by Wayne Ohmer on 6/3/16.
//  Copyright © 2016 Wayne Ohmer. All rights reserved.
//

import UIKit

class DVODateFormatter {
    
    class func formattedDate(date: NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM-dd-yyyy hh:mm a"
        return formatter.stringFromDate(date)
    }

}
