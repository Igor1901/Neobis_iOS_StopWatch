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
    
    var timer: Timer?
    var startDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTimerLabel()
    }
    func updateTimerLabel() {
           var elapsedTime: TimeInterval = 0

           if let startDate = startDate {
               elapsedTime = -startDate.timeIntervalSinceNow
           }

           let minutes = Int(elapsedTime / 60)
           let seconds = Int(elapsedTime.truncatingRemainder(dividingBy: 60))
           let milliseconds = Int((elapsedTime * 1000).truncatingRemainder(dividingBy: 1000))

           timerLabel.text = String(format: "%02d:%02d.%03d", minutes, seconds, milliseconds)
       }

    @IBAction func startButtonTapped(_ sender: UIButton) {
        // Старт таймера
        startDate = Date()
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        startButton.isEnabled = false
        stopButton.isEnabled = true
    }

    @IBAction func stopButtonTapped(_ sender: UIButton) {
        // Остановка таймера
        timer?.invalidate()
        timer = nil
        startDate = nil
        startButton.isEnabled = true
        stopButton.isEnabled = false
    }


    @IBAction func resetButtonTapped(_ sender: UIButton) {
        // Сброс таймера
        timer?.invalidate()
        timer = nil
        startDate = nil
        startButton.isEnabled = true
        stopButton.isEnabled = false
        updateTimerLabel()
    }


       @objc func updateTimer() {
           updateTimerLabel()
       }
   }



