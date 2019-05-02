//
//  TimerModel.swift
//  光目覚まし
//
//  Created by 目良渉 on 2019/04/15.
//  Copyright © 2019 Wataru Mera. All rights reserved.
//


import UIKit
import Foundation

protocol TimerModelDelegate {
    func toggleTorch(with brightness: Float)
    func toggleBackLight(with brightness: Float)
    func playAudio()
}

class TimerModel {
    
    var lightUpInterval: Int = UserDefaults.standard.integer(forKey: Keys.lightUpIntervalKey)
    
    var timer: Timer!
    
    var delegate: TimerModelDelegate?
    
    func lightUpWithInterval(){
        print("entered to the light up timer")
        //test
        print("Light up interval is \(lightUpInterval) seconds")
        var lightStrength: Float = 0
        let numberOfIntervals = 10
        var currentinterval = 0
        guard let controller = self.delegate else {
            print("Delegate of Timer Model is nil")
            return
        }
        timer = Timer.scheduledTimer(withTimeInterval: Double(lightUpInterval), repeats: true) { (timer) in
            print("light up timer fires")
            currentinterval += 1
            lightStrength = Float(currentinterval) / Float(numberOfIntervals)
            controller.toggleTorch(with: lightStrength)
            controller.toggleBackLight(with: lightStrength)
            print(lightStrength)
            if currentinterval >= 10 {
                controller.playAudio()
                timer.invalidate()
            }
            controller.toggleTorch(with: lightStrength)
        }
    }
    
    
}
