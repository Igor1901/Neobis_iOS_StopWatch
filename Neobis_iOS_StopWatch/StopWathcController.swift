//
//  ViewController.swift
//  Neobis_iOS_StopWatch
//
//  Created by Игорь Пачкин on 30/12/23.
//

import UIKit

class StopWathcController: UIViewController {

    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    var stopWatch = Date(timeIntervalSinceReferenceDate: 0)
    
  
    
    var time: Timer?
    var count = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTimerLabel()
    }
    
    func updateTimerLabel() { // обновление времени на лэйбле

        time = Timer.scheduledTimer(timeInterval: 0.01,
                                    target: self,
                                    selector: #selector(updateTimer), 
                                    userInfo: nil,
                                    repeats: true)

       }

    @IBAction func startButtonTapped(_ sender: UIButton) {
    }

    @IBAction func stopButtonTapped(_ sender: UIButton) {
    }

    @IBAction func resetButtonTapped(_ sender: UIButton) {
    }


       @objc func updateTimer() {
           count = count + 10
           let time = millisecondsToMinutesSecondsMilliseconds(milliseconds: count)
           let timeString = makeTimeString(minutes: time.0, seconds: time.1, milliseconds: time.2)
           timerLabel.text = timeString
           
       }
    
    func millisecondsToMinutesSecondsMilliseconds(milliseconds: Int) -> (Int, Int, Int) {
        let totalSeconds = milliseconds / 1000
        return ((totalSeconds / 60), (totalSeconds % 60), (milliseconds % 1000))
    }
    
    func makeTimeString(minutes: Int, seconds: Int, milliseconds: Int) -> String {
        let timeString = String(format: "%02d:%02d:%02d", minutes, seconds, milliseconds % 1000 / 10)
        return timeString
    }
    
   }



