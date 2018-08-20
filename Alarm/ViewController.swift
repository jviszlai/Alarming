//
//  ViewController.swift
//  Alarm
//
//  Created by Joshua Viszlai on 5/24/18.
//  Copyright © 2018 Joshua Viszlai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var detailsBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var alarmsTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var detailContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Initially hide details
        detailsBottomConstraint = detailsBottomConstraint.setMultiplier(multiplier: 0.06)
        alarmsTopConstraint = alarmsTopConstraint.setMultiplier(multiplier: 0.06)
        self.detailContainer.isHidden = true
        
        // Do any additional setup after loading the view, typically from a nib.
        // When to hide details
        NotificationCenter.default.addObserver(self, selector: #selector(hideDetails(_:)), name: NSNotification.Name("Cancel"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideDetails(_:)), name: NSNotification.Name("UpdateAlarm"), object: nil)
        // When to show details
        NotificationCenter.default.addObserver(self, selector: #selector(showDetails(_:)), name: NSNotification.Name("NewAlarm"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showDetails(_:)), name: NSNotification.Name("EditAlarm"), object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Private Methods
    
    @objc private func hideDetails(_ notification: NSNotification) {
        self.detailContainer.isHidden = true
        detailsBottomConstraint = detailsBottomConstraint.setMultiplier(multiplier: 0.06)
        alarmsTopConstraint = alarmsTopConstraint.setMultiplier(multiplier: 0.06)
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @objc private func showDetails(_ notification: NSNotification) {
        self.detailContainer.isHidden = false
        detailsBottomConstraint = detailsBottomConstraint.setMultiplier(multiplier: 1)
        alarmsTopConstraint = alarmsTopConstraint.setMultiplier(multiplier: 1)
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
}

