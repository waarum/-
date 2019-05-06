//
//  SettingViewController.swift
//  光目覚まし
//
//  Created by 目良渉 on 2019/04/15.
//  Copyright © 2019 Wataru Mera. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let lightUpIntervals = [1, 60, 300, 600, 1800]
    let lightUpIntervalTitles: [String] = ["1秒", "1分","5分","10分", "30分"]
    
    
    @IBOutlet weak var intervalPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        intervalPicker.dataSource = self
        intervalPicker.delegate = self
        if let index = lightUpIntervals.firstIndex(of: UserDefaults.standard.integer(forKey: Keys.lightUpInterval)) {
            intervalPicker.selectRow(index, inComponent: 0, animated: false)
        }
    }
    
    @IBAction func goBackButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return lightUpIntervals.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(lightUpIntervalTitles[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        UserDefaults.standard.set(lightUpIntervals[row], forKey: Keys.lightUpInterval)
        print("Light up interval is \(lightUpIntervals[row]) seconds")
    }
}
