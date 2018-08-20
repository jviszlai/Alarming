//
//  Alarm.swift
//  Alarm
//
//  Created by Joshua Viszlai on 5/29/18.
//  Copyright © 2018 Joshua Viszlai. All rights reserved.
//

import UIKit
import os.log

class Alarm: NSObject, NSCoding {
    
    //MARK: Properties
    var label: String
    var date: Date
    var daysOfWeek = [Int]()
    var enabled = false
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("alarms")
    
    
    //MARK: Types
    struct PropertyKey {
        static let label = "label"
        static let date = "date"
        static let daysOfWeek = "daysOfWeek"
        static let enabled = "enabled"
    }
    
    init?(label: String, date: Date, daysOfWeek: [Int], enabled: Bool) {
        if label.isEmpty || daysOfWeek.count != 7 {
            return nil
        }
        self.label = label
        self.date = date
        self.daysOfWeek = daysOfWeek
        self.enabled = enabled
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(label, forKey: PropertyKey.label)
        aCoder.encode(date, forKey: PropertyKey.date)
        aCoder.encode(daysOfWeek, forKey: PropertyKey.daysOfWeek)
        aCoder.encode(enabled, forKey: PropertyKey.enabled)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let label = aDecoder.decodeObject(forKey: PropertyKey.label) as? String else {
            os_log("Unable to decode the label of an alarm object", log: OSLog.default, type: .debug)
            return nil
        }
        guard let date = aDecoder.decodeObject(forKey: PropertyKey.date) as? Date else {
            os_log("Unable to decode the date of an alarm object", log: OSLog.default, type: .debug)
            return nil
        }
        guard let daysOfWeek = aDecoder.decodeObject(forKey: PropertyKey.daysOfWeek) as? [Int] else {
            os_log("Unable to decode the days of week array of an alarm object", log: OSLog.default, type: .debug)
            return nil
        }
        guard let enabled = aDecoder.decodeObject(forKey: PropertyKey.enabled) as? Bool else {
            os_log("Unable to decode the days of week array of an alarm object", log: OSLog.default, type: .debug)
            return nil
        }
        self.init(label: label, date: date, daysOfWeek: daysOfWeek, enabled: enabled)
    }
    
}
