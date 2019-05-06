//
//  ViewController.swift
//  光目覚まし
//
//  Created by 目良渉 on 2019/02/11.
//  Copyright © 2019 Wataru Mera. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation

class AlarmSetViewController: UIViewController {
    
    
    @IBOutlet weak var lightSlider: UISlider!
    
    @IBOutlet weak var wakeUpTimePicker: UIPickerView!
    
    var hours:[Int] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23]
    var minutes:[Int] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59]
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPicker()
        }

}

extension AlarmSetViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    // set up the outlets
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return hours.count
        default:
            return minutes.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return String(hours[row])
        default:
            return String(minutes[row])
        }
    }
    
    // How it works
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            defaults.set(hours[row], forKey: Keys.hour)
        default:
            defaults.set(minutes[row], forKey: Keys.minute)
        }
    }
    
    // Set up in launching
    func setUpPicker() {
        wakeUpTimePicker.delegate = self
        wakeUpTimePicker.dataSource = self
        defaults.register(defaults: [Keys.hour: 7, Keys.minute: 0])
        let hour = defaults.integer(forKey: Keys.hour)
        let minute = defaults.integer(forKey: Keys.minute)
        wakeUpTimePicker.selectRow(hour, inComponent: 0, animated: false)
        wakeUpTimePicker.selectRow(minute, inComponent: 1, animated: false)
    }
}
