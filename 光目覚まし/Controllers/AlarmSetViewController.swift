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
    
    let lightIntervals = [1,2,3,4,5,6,7,8,9,10]
    
    var lightUpInterval = 180
    
    let sleepingViewController = SleepingViewController()
    
    @IBOutlet weak var lightSlider: UISlider!
    
    @IBOutlet weak var wakeTimePicker: UIDatePicker!
    
    @IBOutlet weak var intervalPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        intervalPicker.delegate = self
        intervalPicker.dataSource = self
        intervalPicker.selectRow(UserDefaults.standard.integer(forKey: "lightUpInterval") / 60 - 1, inComponent: 0, animated: false)
    }
    
    @IBAction func timerStartButtonAction(_ sender: UIButton) {
        UserDefaults.standard.set("\(wakeTimePicker.date.timeIntervalSinceNow)", forKey: "wakeTime")
        UserDefaults.standard.synchronize()
    }
    

    //MARK: - Light Manipulation
    func toggleTorch(with lightValue: Float) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }

        if device.hasTorch {
            do {
                try device.lockForConfiguration()

                if lightValue == 0 {
                    device.torchMode = .off
                } else {
                    do {
                        try device.setTorchModeOn(level: lightValue)
                    } catch {
                        print("error toggling light")
                    }
                }

                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
    }
    

    

    
    
}

//MARK: - Light up interval picker settings

extension AlarmSetViewController:  UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return lightIntervals.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(lightIntervals[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // The next line is for debuging
        lightUpInterval = lightIntervals[row] * 60
        UserDefaults.standard.set("\(lightUpInterval)", forKey: "lightUpInterval")
        UserDefaults.standard.synchronize()
        print("Light up interval is \(lightUpInterval)")
    }
}
