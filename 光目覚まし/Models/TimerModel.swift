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
    func wakeUp()
}

class TimerModel {
    
    let defaults = UserDefaults.standard
    
    var lightUpInterval: Int = UserDefaults.standard.integer(forKey: Keys.lightUpInterval)
    
    var sleepInterval: Double = 0
    
    var timer: Timer!
    
    var delegate: TimerModelDelegate?
    
    //MARK: - Timer
    func sleepingTimer(){
        let lightUpInterval = Double(defaults.integer(forKey: Keys.lightUpInterval))
        print("start")
        timer = Timer.scheduledTimer(withTimeInterval: sleepInterval - lightUpInterval, repeats: false) { (Timer) in
            print("end")
            self.delegate?.wakeUp()
        }
    }
    func lightUpWithInterval(){
        print("entered the light up timer")
        //test
        print("Light up interval is \(lightUpInterval) seconds")
        var lightStrength: Float = 0
        let numberOfIntervals = 10
        var currentinterval = 0
        guard let controller = self.delegate else {
            print("Delegate of Timer Model is nil")
            return
        }
        timer = Timer.scheduledTimer(withTimeInterval: Double(lightUpInterval / numberOfIntervals), repeats: true) { (timer) in
            print("light up timer fires")
            currentinterval += 1
            lightStrength = Float(currentinterval) / Float(numberOfIntervals)
            controller.toggleTorch(with: lightStrength)
            controller.toggleBackLight(with: lightStrength)
            print(lightStrength)
            if currentinterval >= numberOfIntervals {
                controller.playAudio()
                timer.invalidate()
            }
            controller.toggleTorch(with: lightStrength)
        }
    }
    
    
}
