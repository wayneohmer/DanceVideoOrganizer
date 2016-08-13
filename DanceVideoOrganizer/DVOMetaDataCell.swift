//
//  DVOMetaDataCell.swift
//  DanceVideoOrganizer
//
//  Created by Wayne Ohmer on 6/16/16.
//  Copyright © 2016 Wayne Ohmer. All rights reserved.
//

import UIKit

class DVOMetaDataCell: UITableViewCell {

    @IBOutlet weak var thumbNailImagView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dancersLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
