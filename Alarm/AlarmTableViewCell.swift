//
//  AlarmTableViewCell.swift
//  Alarm
//
//  Created by Joshua Viszlai on 5/29/18.
//  Copyright © 2018 Joshua Viszlai. All rights reserved.
//

import UIKit

class AlarmTableViewCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var days: UILabel!
    @IBOutlet weak var enabled: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
