//
//  DVODateFormatter.swift
//  DanceVideoOrganizer
//
//  Created by Wayne Ohmer on 6/3/16.
//  Copyright © 2016 Wayne Ohmer. All rights reserved.
//

import UIKit

class DVODateFormatter {
    
    class func formattedDate(_ date: Date?) -> String {
        guard let date = date else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "EE MM-dd-yyyy hh:mm a"
        return formatter.string(from: date)
    }

}
