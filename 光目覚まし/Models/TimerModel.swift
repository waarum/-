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
    
    var sleepingTime: Double = 0
    
    var timer: Timer!
    
    var delegate: TimerModelDelegate?
    
    //MARK: - Timer
    func sleepingTimer(){
        let sleepInterval = calculateInterval()
        print("start")
        timer = Timer.scheduledTimer(withTimeInterval: sleepInterval, repeats: false) { (Timer) in
            print("end")
            self.delegate?.wakeUp()
        }
    }
    
    //MARK: - Caluculate sleep Interval
    func calculateInterval() -> Double {
        let hour = defaults.integer(forKey: Keys.hour)
        let minute = defaults.integer(forKey: Keys.minute)
        let wakeUpTimeInSeconds = (hour * 60 + minute) * 60
        let calendar = Calendar(identifier: .gregorian)
        let date = Date()
        let currentTime = calendar.dateComponents([.hour, .minute, .second], from: date)
        let currentHourInSeconds = currentTime.hour! * 3600
        let currentMinuteInSeconds = currentTime.minute! * 60
        let currenTimeInSeconds = currentHourInSeconds + currentMinuteInSeconds + currentTime.second!
        var interval = wakeUpTimeInSeconds - currenTimeInSeconds
        if interval < 0 {
            interval = interval + 60 * 60 * 24
        }
        print("Sleep for \(interval / 3600):\((interval / 60) % 60):\(interval % 60)")
        return Double(interval)
    }
    
    func lightUpWithInterval(){
        print("entered to the light up timer")
        //test
        print("Light up interval is \(lightUpInterval)")
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
