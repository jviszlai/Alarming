//
//  AlarmTableViewController.swift
//  Alarm
//
//  Created by Joshua Viszlai on 5/29/18.
//  Copyright © 2018 Joshua Viszlai. All rights reserved.
//

import UIKit
import os.log
import UserNotifications

class AlarmTableViewController: UITableViewController {
    //MARK: Properties
    
    static var alarms = [Alarm]()
    var selectedIndexPath: IndexPath?
    var editingAlarm = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        if let savedAlarms = loadAlarms() {
            AlarmTableViewController.alarms += savedAlarms
        } else {
            loadSampleAlarms()
        }
        Scheduler.updateSchedule()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateAlarm(_:)), name: NSNotification.Name("UpdateAlarm"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.deselect(_:)), name: NSNotification.Name("Cancel"), object: nil)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AlarmTableViewController.alarms.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "AlarmTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AlarmTableViewCell else {
            fatalError("The dequeued cell is not an instance of AlarmTableViewCell.")
        }
        let alarm = AlarmTableViewController.alarms[indexPath.row]
        cell.label.text = alarm.label
        cell.time.text = alarm.date.toString(format: "hh:mm a")
        if alarm.enabled {
            cell.enabled.backgroundColor = UIColor.green
        } else {
            cell.enabled.backgroundColor = UIColor.red
        }
        var days = ""
        for (index, day) in alarm.daysOfWeek.enumerated() {
            if day == 1 {
                switch index {
                case 0:
                    days += "Su "
                case 1:
                    days += "Mo "
                case 2:
                    days += "Tu "
                case 3:
                    days += "We "
                case 4:
                    days += "Th "
                case 5:
                    days += "Fr "
                case 6:
                    days += "Sa"
                default:
                    break
                }
            }
        }
        cell.days.text = days
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if editingAlarm {
            editingAlarm = false
            NotificationCenter.default.post(name: NSNotification.Name("Cancel"), object: nil)
        } else {
            editingAlarm = true
            let sendAlarm = AlarmTableViewController.alarms[indexPath.row]
            let alarmDataDict:[String: Alarm] = ["editAlarm": sendAlarm]
            NotificationCenter.default.post(name: NSNotification.Name("EditAlarm"), object: nil, userInfo: alarmDataDict)
        }
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Remove from list
            AlarmTableViewController.alarms.remove(at: indexPath.row)
            saveAlarms()
            Scheduler.updateSchedule()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }  
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Private Methods
    
    private func loadSampleAlarms() {
        /*guard let alarm1 = Alarm(label: "One", date: Date(), daysOfWeek: [0,0,0,0,0,0,0]) else {
            fatalError("Unable to instantiate alarm")
        }
        AlarmTableViewController.alarms += [alarm1]*/
    }
    
    @objc private func updateAlarm(_ notification: NSNotification) {
        if let alarm = notification.userInfo?["newAlarm"] as? Alarm {
            if let selectedPath = tableView.indexPathForSelectedRow {
                AlarmTableViewController.alarms[selectedPath.row] = alarm
                tableView.reloadRows(at: [selectedPath], with: .none)
            } else {
                let newIndexPath = IndexPath(row: AlarmTableViewController.alarms.count, section: 0)
                AlarmTableViewController.alarms.append(alarm)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            saveAlarms()
            Scheduler.updateSchedule()
        }
    }
    
    @objc private func deselect(_ notification: NSNotification) {
        editingAlarm = false
        if let selectedPath = tableView.indexPathForSelectedRow {
            tableView.reloadRows(at: [selectedPath], with: .none)
        }
    }
    
    private func saveAlarms() {
        editingAlarm = false
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(AlarmTableViewController.alarms, toFile: Alarm.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Alarms saved successfully.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save alarms.", log: OSLog.default, type: .debug)
        }
    }
    
    private func loadAlarms() -> [Alarm]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Alarm.ArchiveURL.path) as? [Alarm]
    }
    

}
