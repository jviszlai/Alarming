//
//  Date+toString.swift
//  Alarm
//
//  Created by Joshua Viszlai on 5/30/18.
//  Copyright © 2018 Joshua Viszlai. All rights reserved.
//

import Foundation

extension Date {
    func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
