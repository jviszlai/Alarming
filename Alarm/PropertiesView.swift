//
//  PropertiesView.swift
//  Alarm
//
//  Created by Joshua Viszlai on 5/24/18.
//  Copyright © 2018 Joshua Viszlai. All rights reserved.
//

import UIKit

class PropertiesView: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var textField: UITextField!
    var alarm: Alarm?
    var newDaysOfWeek = [0,0,0,0,0,0,0]
    var oldLabel = "Alarm"
    @IBOutlet var dayButtons: Array<UIButton>!
    @IBOutlet weak var datePicker: UIDatePicker!
    var enabled = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.addObserver(self, selector: #selector(self.createAlarm(_:)), name: NSNotification.Name("NewAlarm"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.editAlarm(_:)), name: NSNotification.Name("EditAlarm"), object: nil)
        
        self.textField.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //MARK: Private Methods
    
    @objc private func createAlarm(_ notification: NSNotification) {
        newDaysOfWeek = [0,0,0,0,0,0,0]
        oldLabel = "Alarm"
        for button in dayButtons {
            button.isSelected = false
        }
        textField.text = ""
    }
    
    @IBAction private func saveAlarm(_ sender: Any) {
        self.view.endEditing(true)
        let label = textField.text ?? ""
        guard let newAlarm = Alarm(label: label.isEmpty ? oldLabel : label, date: datePicker.date, daysOfWeek: newDaysOfWeek, enabled: enabled) else {
            fatalError("Failed to instantiate new alarm")
        }
        let alarmDataDict:[String: Alarm] = ["newAlarm": newAlarm]
        NotificationCenter.default.post(name: NSNotification.Name("UpdateAlarm"), object: nil, userInfo: alarmDataDict)
    }
    
    @IBAction private func cancel(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("Cancel"), object: nil)
    }
    
    @IBAction private func enable(_ sender: UIButton) {
        if enabled {
            enabled = false
            sender.setTitle("OFF", for: .normal)
            sender.backgroundColor = UIColor.red
        } else {
            enabled = true
            sender.setTitle("ON", for: .normal)
            sender.backgroundColor = UIColor.green
        }
    }
    
    @objc private func editAlarm(_ notification: NSNotification) {
        if let alarm = notification.userInfo?["editAlarm"] as? Alarm {
            oldLabel = alarm.label
            newDaysOfWeek = alarm.daysOfWeek
            textField.text = alarm.label
            datePicker.date = alarm.date
            for (index, button) in dayButtons.enumerated() {
                if newDaysOfWeek[index] == 1 {
                    button.isSelected = true
                } else {
                    button.isSelected = false
                }
            }
        }
    }
    
    @IBAction private func chooseDayOfWeek(_ sender: Any) {
        guard let button = sender as? UIButton else {
            return
        }
        if newDaysOfWeek[button.tag] == 0 {
            button.isSelected = true
            newDaysOfWeek[button.tag] = 1
        } else {
            button.isSelected = false
            newDaysOfWeek[button.tag] = 0
        }
    }
    
}
