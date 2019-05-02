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
    
    @IBOutlet weak var wakeTimePicker: UIDatePicker!
    
    var time = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.register(defaults: [Keys.wakeUpTimeKey: time])
        print(time)
        if let previousTime = UserDefaults.standard.object(forKey: Keys.wakeUpTimeKey) as? Date {
        print(previousTime)
        wakeTimePicker.setDate(previousTime, animated: false)
        }
    }
    
    @IBAction func timerStartButtonAction(_ sender: UIButton) {
        UserDefaults.standard.set(wakeTimePicker.date, forKey: Keys.wakeUpTimeKey)
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
