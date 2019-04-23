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
    
    var audioPlayer:AVAudioPlayer!
    
    var timerModel = TimerModel()
    
    let lightUpInterval = UserDefaults.standard.integer(forKey: Keys.lightUpIntervalKey)
    
    var timer: Timer!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet var backGroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isIdleTimerDisabled = true
        prepareAudio()
//        sleepingTimer()
        toggleBackLight(with: 0)
        backGroundView.backgroundColor = UIColor.black
        timerModel.delegate = self
        // for test
        timerModel.lightUpWithInterval()
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
        var interval = UserDefaults.standard.double(forKey: "wakeTime")
        if interval < 0 {
            interval = 864000 + interval
        }
        interval = interval - Double(lightUpInterval) * 10
        //        if interval < 0 {
        //            self.dismiss(animated: true, completion: nil)
        //        }
        print("Sleep for \(interval) seconds")
        return interval
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
