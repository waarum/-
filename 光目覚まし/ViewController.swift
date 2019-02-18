//
//  ViewController.swift
//  光目覚まし
//
//  Created by 目良渉 on 2019/02/11.
//  Copyright © 2019 Wataru Mera. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var lightSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK: - Slider (for Test)
    
    @IBAction func sliter(_ sender: UISlider) {
        toggleTorch(with: sender.value)
    }
    
    //MARK: - Timer
    
    


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

