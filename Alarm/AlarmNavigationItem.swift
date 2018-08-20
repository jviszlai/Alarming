//
//  AlarmNavigationItem.swift
//  Alarm
//
//  Created by Joshua Viszlai on 5/29/18.
//  Copyright © 2018 Joshua Viszlai. All rights reserved.
//

import UIKit

class AlarmNavigationItem: UINavigationItem {

    @IBAction func newAlarm(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("NewAlarm"), object: nil)
    }
    
}
