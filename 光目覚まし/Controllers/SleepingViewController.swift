//
//  SleepingViewController.swift
//  光目覚まし
//
//  Created by 目良渉 on 2019/03/14.
//  Copyright © 2019 Wataru Mera. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation
import AudioToolbox

class SleepingViewController: UIViewController, AVAudioPlayerDelegate {
    
    let defaults = UserDefaults.standard
    
    var audioPlayer:AVAudioPlayer!
    
    var timerModel = TimerModel()
    
    var sleepInterval: Double = 0
    
    var timer: Timer!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet var backGroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isIdleTimerDisabled = true
        prepareAudio()
        toggleBackLight(with: 0)
        backGroundView.backgroundColor = UIColor.black
        timerModel.delegate = self
        timerModel.sleepInterval = sleepInterval
        timerModel.sleepingTimer()
    }
    
    @IBAction func stopButton(_ sender: UIButton) {
        UIApplication.shared.isIdleTimerDisabled = false
        timerModel.timer.invalidate()
        toggleTorch(with: 0)
        toggleBackLight(with: 0.3)
        print(UIScreen.main.brightness)
        audioPlayer.stop()
        print("stop")
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Timer
    func sleepingTimer(){
        let sleepInterval = calculateInterval()
        print("start")
        timer = Timer.scheduledTimer(withTimeInterval: sleepInterval, repeats: false) { (Timer) in
            print("end")
            self.timeLabel.text = "おはよう！"
            self.timeLabel.textColor = UIColor.black
            self.backGroundView.backgroundColor = UIColor.white
            self.timerModel.lightUpWithInterval()
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
}
//MARK: - Light Manipulation and audio
extension SleepingViewController: TimerModelDelegate {
    
    func toggleTorch(with brightness: Float) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                
                if brightness == 0 {
                    device.torchMode = .off
                } else {
                    do {
                        try device.setTorchModeOn(level: brightness)
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
    
    func toggleBackLight(with brightness: Float){
        UIScreen.main.brightness = CGFloat(brightness)
    }
    
    func playAudio(){
        audioPlayer.play()
    }
    
    func wakeUp(){
        self.timeLabel.text = "おはよう！"
        self.timeLabel.textColor = UIColor.black
        self.backGroundView.backgroundColor = UIColor.white
        self.timerModel.lightUpWithInterval()
    }
}


// Prapare Audio Player
extension SleepingViewController {
    func prepareAudio(){
        // 再生する audio ファイルのパスを取得
        let audioPath = Bundle.main.path(forResource: "1", ofType:"mp3")!
        let audioUrl = URL(fileURLWithPath: audioPath)
        
        
        // auido を再生するプレイヤーを作成する
        var audioError:NSError?
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioUrl)
        } catch let error as NSError {
            audioError = error
            audioPlayer = nil
        }
        
        // エラーが起きたとき
        if let error = audioError {
            print("Error \(error.localizedDescription)")
        }
        
        audioPlayer.delegate = self
        audioPlayer.prepareToPlay()
    }
}
