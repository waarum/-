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

class AlermSetViewController: UIViewController {
    
    
    let lightIntervals = [1,2,3,4,5,6,7,8,9,10]
    
    var lightInterval = 3
    
    @IBOutlet weak var lightSlider: UISlider!
    
    @IBOutlet weak var wakeTimePicker: UIDatePicker!
    
    @IBOutlet weak var intervalPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        intervalPicker.delegate = self
        intervalPicker.dataSource = self
    }
    
    //MARK: - Slider (for Test)
    
    @IBAction func sliter(_ sender: UISlider) {
        toggleTorch(with: sender.value)
    }
    
    @IBAction func timerStartButtonAction(_ sender: UIButton) {
        UIApplication.shared.isIdleTimerDisabled = true
        sleepingTimer()
    }
    
    //MARK: - Set Time
    func setTime() -> Date {
        let wakeTime = wakeTimePicker.date
        return wakeTime
    }
    
    
    //MARK: - Timer
    func lightUpTimer(){
        
        var lightStrength: Float = 0
        let numberOfIntervals = 10
        var currentinterval = 0
        
        Timer.scheduledTimer(withTimeInterval: Double(lightInterval), repeats: true) { (Timer) in
            currentinterval += 1
            lightStrength = Float(currentinterval) / Float(numberOfIntervals)
            self.toggleTorch(with: lightStrength)
            print(lightStrength)
            if currentinterval >= 10 {
                Timer.invalidate()
            }
            self.toggleTorch(with: lightStrength)
        }
        
        print(setTime())
    }
    
    //MARK: - Start the light up timer
    func sleepingTimer(){
        let sleepInterval = calculateInterval()
        print("start")
        Timer.scheduledTimer(withTimeInterval: sleepInterval, repeats: false) { (Timer) in
            self.lightUpTimer()
            print("end")
        }
    }

    //MARK: - Caluculate sleep Interval
    func calculateInterval() -> Double {
        var interval = wakeTimePicker.date.timeIntervalSinceNow
        if interval < 0 {
            interval = 864000 + interval
        }
        print(interval)
        return interval
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

extension AlermSetViewController:  UIPickerViewDataSource, UIPickerViewDelegate {
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
        lightInterval = lightIntervals[row] * 60
        print("Light up interval is \(lightInterval)")
    }
}
