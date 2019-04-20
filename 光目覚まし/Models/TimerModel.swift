//
//  TimerModel.swift
//  光目覚まし
//
//  Created by 目良渉 on 2019/04/15.
//  Copyright © 2019 Wataru Mera. All rights reserved.
//


import UIKit
import AVFoundation
import Foundation
import AudioToolbox

protocol TimerModelDelegate {
    func toggleTorch(with brightness: Float)
    func toggleBackLight(with brightness: Float)
}

class TimerModel: Timer {
    var audioPlayer:AVAudioPlayer!
    
    let lightUpInterval = UserDefaults.standard.integer(forKey: "lightUpInterval")
    
    var delegate: TimerModelDelegate?
    
    func lightUpWithInterval(){
            
    }
    
    
}
