//
//  ViewController.swift
//  Neobis_iOS_StopWatch
//
//  Created by Игорь Пачкин on 30/12/23.
//

import UIKit

class StopWathcController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    // MARK: - interface elements
    @IBOutlet weak var stopWatch: UISegmentedControl!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    
  
    
    var time: Timer?
    var count = 0
    var isTimerRunning = false
    
    
    let hoursData = Array(0...23)
    let minutesData = Array(0...59)
    let secondsData = Array(0...59)
    
    var selectedHour = 0
    var selectedMinute = 0
    var selectedSecond = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        updateTimerLabel()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
    }
    
    func updateTimerLabel() { // обновление времени на лэйбле

        time = Timer.scheduledTimer(timeInterval: 0.01,
                                    target: self,
                                    selector: #selector(updateTimer), 
                                    userInfo: nil,
                                    repeats: true)

       }

    @IBAction func startButtonTapped(_ sender: UIButton) {
        if isTimerRunning {
            // Секундомер уже работает, значит это действие будет паузой
            stopTimer()
        } else {
            // Секундомер не работает, начинаем его
            startTimer()
        }

    }

    @IBAction func stopButtonTapped(_ sender: UIButton) {
        stopTimer()
    }

    @IBAction func resetButtonTapped(_ sender: UIButton) {
        resetTimer()
    }


       @objc func updateTimer() {
           if isTimerRunning {
               count = count + 10
               let time = millisecondsToMinutesSecondsMilliseconds(milliseconds: count)
               let timeString = makeTimeString(minutes: time.0, seconds: time.1, milliseconds: time.2)
               timerLabel.text = timeString
           }
       }
    
    func startTimer() {
        isTimerRunning = true
        startButton.isEnabled = false
        stopButton.isEnabled = true
        resetButton.isEnabled = true
    }

    func stopTimer() {
        isTimerRunning = false
        startButton.isEnabled = true
        stopButton.isEnabled = false
        resetButton.isEnabled = true
    }

    func resetTimer() {
        isTimerRunning = false
        count = 0
        let time = millisecondsToMinutesSecondsMilliseconds(milliseconds: count)
        let timeString = makeTimeString(minutes: time.0, seconds: time.1, milliseconds: time.2)
        timerLabel.text = timeString

        startButton.isEnabled = true
        stopButton.isEnabled = false
        resetButton.isEnabled = false
    }
    
    func millisecondsToMinutesSecondsMilliseconds(milliseconds: Int) -> (Int, Int, Int) {
        let totalSeconds = milliseconds / 1000
        return ((totalSeconds / 60), (totalSeconds % 60), (milliseconds % 1000))
    }
    
    func makeTimeString(minutes: Int, seconds: Int, milliseconds: Int) -> String {
        let timeString = String(format: "%02d:%02d:%02d", minutes, seconds, milliseconds % 1000 / 10)
        return timeString
    }
    
    // MARK: - UIPickerViewDataSource
     
     func numberOfComponents(in pickerView: UIPickerView) -> Int {
         return 3 // количество колонок
     }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return hoursData.count
        case 1:
            return minutesData.count
        case 2:
            return secondsData.count
        default:
            return 0
        }
    }
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(hoursData[row])"
        case 1:
            return "\(minutesData[row])"
        case 2:
            return "\(secondsData[row])"
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            selectedHour = hoursData[row]
        case 1:
            selectedMinute = minutesData[row]
        case 2:
            selectedSecond = secondsData[row]
        default:
            break
        }
        
        updateSelectedValueLabel()
    }
    
    func updateSelectedValueLabel() {
        timerLabel.text = String(format: "%02d:%02d:%02d", selectedHour, selectedMinute, selectedSecond)
    }
    
    
   }



