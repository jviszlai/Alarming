//
//  Scheduler.swift
//  Alarm
//
//  Created by Joshua Viszlai on 6/18/18.
//  Copyright © 2018 Joshua Viszlai. All rights reserved.
//

import Foundation
import UserNotifications
import CoreMotion

class Scheduler {
    static var nextAlarm: Alarm? = nil
    static var alarmDay = -1
    static var currentTimer = Timer()
    static let pedometer = CMPedometer()
    
    static func runTimer() {
        if nextAlarm != nil {
            var timeDiff = Calendar.current.dateComponents([.second], from: Date(), to: nextAlarm!.date).second
            if timeDiff == nil {
                print("Time difference calculation failed")
            } else {
                let today = Calendar.current.dateComponents([.weekday], from: Date()).weekday
                timeDiff! += (alarmDay - (today! - 1)) * 86400
                if timeDiff! < 0 {
                    timeDiff! += 604800
                }
                print("Scheduled!")
                print(timeDiff!)
                currentTimer = Timer.scheduledTimer(timeInterval: TimeInterval(timeDiff!), target: self, selector: #selector(timerEnd), userInfo: nil, repeats: false)
            }
        }
    }
    
    @objc static func timerEnd() {
        let content = UNMutableNotificationContent()
        content.title = nextAlarm!.label
        content.sound = UNNotificationSound.default()
        let triggerDate = Calendar.current.dateComponents([.nanosecond], from: nextAlarm!.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
        let identifier = String(UInt(bitPattern: ObjectIdentifier(nextAlarm!)))
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
            if error != nil {
                print("Notification failed")
            }
        })
        Scheduler.pedometer.startUpdates(from: Date(), withHandler: { data, error in
            if data != nil {
                if (data!.numberOfSteps).intValue > 20 {
                    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                    Scheduler.pedometer.stopUpdates()
                    updateSchedule()
                }
            }
        })
    }
    
    static func updateSchedule() {
        var smallestTime = -1
        var next: Alarm? = nil
        var nextDay = -1
        for alarm in AlarmTableViewController.alarms {
            if alarm.enabled {
                let today = Calendar.current.dateComponents([.weekday], from: Date()).weekday
                for day in 0...6 {
                    if alarm.daysOfWeek[day] == 1 {
                        var timeDiff = Calendar.current.dateComponents([.second], from: Date(), to: alarm.date).second
                        if timeDiff == nil {
                            print("Time difference calculation failed")
                        } else {
                            timeDiff! += (day - (today! - 1)) * 86400
                            if timeDiff! < 0 {
                                timeDiff! += 604800
                            }
                            if smallestTime == -1 || timeDiff! < smallestTime {
                                smallestTime = timeDiff!
                                next = alarm
                                nextDay = day
                            }
                        }
                    }
                }
            }
        }
        nextAlarm = next
        alarmDay = nextDay
        print("Canceled!")
        currentTimer.invalidate()
        currentTimer = Timer()
        Scheduler.runTimer()
    }
}
