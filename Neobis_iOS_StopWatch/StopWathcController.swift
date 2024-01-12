//
//  ViewController.swift
//  Neobis_iOS_StopWatch
//
//  Created by Игорь Пачкин on 30/12/23.
//

import UIKit

class StopWathcController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    // MARK: - interface elements
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var logoImage: UIImageView!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    //for stopWatch
    var time: Timer?
    var count = 0
    var isStopWatchRunning = false
    
    // for timer
    var countDownSeconds: Int = 0
    var initialCountDownSeconds: Int = 0
    var isTimerRunning: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //updateStopWatchLabel()
        
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        updateUIForSelectedSegment()
        //updateTimerLabelFromPicker()
        
    }
    
    @objc func segmentedControlValueChanged() {
        // Вызывается при изменении значения UISegmentedControl
        updateUIForSelectedSegment()
    }
    
    func updateUIForSelectedSegment() {
        // Обновляем UI в зависимости от выбранного сегмента
        let selectedIndex = segmentedControl.selectedSegmentIndex
        if selectedIndex == 0 {
            // Режим секундомера
            timeLabel.text = "00:00:00"
            pickerView.isHidden = true
            startButton.isEnabled = true
            stopButton.isEnabled = true
            resetButton.isEnabled = false
            logoImage.image = UIImage(systemName: "stopwatch")
            updateStopWatchLabel() //???
        } else {
            // Режим пикера
            print()
            pickerView.isHidden = false
            updateTimerLabelFromPicker()
            logoImage.image = UIImage(systemName: "timer")
        }
        
        // Сброс секундомера, если он был запущен
        stopStopWatch()
    }
    func updateStopWatchLabel() { // обновление времени на лэйбле
        
        time = Timer.scheduledTimer(timeInterval: 0.01,
                                    target: self,
                                    selector: #selector(updateStopWatch), 
                                    userInfo: nil,
                                    repeats: true)
        
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        let selectedIndex = segmentedControl.selectedSegmentIndex
        if selectedIndex == 0 {
            if isStopWatchRunning {
                // Секундомер уже работает, значит это действие будет паузой
                stopStopWatch()
            } else {
                // Секундомер не работает, начинаем его
                startStopWatch()
            }
        } else if selectedIndex == 1 {
            // Запуск отсчета времени из пикера
            if isTimerRunning {
                // Таймер уже работает, значит это действие будет паузой
                pauseTimer()
            } else {
                // Таймер не работает, начинаем его
                startTimer()
            }
        }
        
    }
    
    @IBAction func stopButtonTapped(_ sender: UIButton) {
        let selectedIndex = segmentedControl.selectedSegmentIndex
        if selectedIndex == 0 {
            // Режим секундомера
            stopStopWatch()
        } else if selectedIndex == 1 {
            // Режим пикера
            pauseTimer()
        }
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        let selectedIndex = segmentedControl.selectedSegmentIndex
        if selectedIndex == 0 {
            // Режим секундомера
            resetStopWatch()
        } else if selectedIndex == 1 {
            // Режим пикера
            resetTimer()
        }
        
    }
    
    
    @objc func updateStopWatch() {
        if isStopWatchRunning {
            count = count + 10
            let time = millisecondsToMinutesSecondsMilliseconds(milliseconds: count)
            let timeString = makeTimeString(minutes: time.0, seconds: time.1, milliseconds: time.2)
            timeLabel.text = timeString
        }
    }
    
    func startStopWatch() {
        isStopWatchRunning = true
        startButton.isEnabled = false
        stopButton.isEnabled = true
        resetButton.isEnabled = true
    }
    
    func stopStopWatch() {
        isStopWatchRunning = false
        startButton.isEnabled = true
        stopButton.isEnabled = true
        resetButton.isEnabled = true
    }
    
    func resetStopWatch() {
        isStopWatchRunning = false
        count = 0
        let time = millisecondsToMinutesSecondsMilliseconds(milliseconds: count)
        let timeString = makeTimeString(minutes: time.0, seconds: time.1, milliseconds: time.2)
        timeLabel.text = timeString
        
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
    
    //MARK: - Picker
    
    // MARK: - Timer Handling
    
    func updateTimerLabelFromPicker() {
        let selectedRowHour = pickerView.selectedRow(inComponent: 0)
        let selectedRowMinute = pickerView.selectedRow(inComponent: 1)
        let selectedRowSecond = pickerView.selectedRow(inComponent: 2)
        
        countDownSeconds = selectedRowHour * 3600 + selectedRowMinute * 60 + selectedRowSecond
        initialCountDownSeconds = countDownSeconds
        updateTimeLabel()
    }
    
    func updateTimeLabel() {
        let time = secondsToHoursMinutesSeconds(seconds: countDownSeconds)
        let timeString = String(format: "%02d:%02d:%02d", time.0, time.1, time.2)
        timeLabel.text = timeString
    }
    
    func secondsToHoursMinutesSeconds(seconds: Int) -> (Int, Int, Int) {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let seconds = seconds % 60
        
        return (hours, minutes, seconds)
    }
    
    // MARK: - Start Countdown

   func startTimer() {
       isTimerRunning = true
       pickerView.isHidden = true
       time = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
   }

   func pauseTimer() {
       isTimerRunning = false
       time?.invalidate()
   }


   func resetTimer() {
       isTimerRunning = false
       pickerView.isHidden = false
       countDownSeconds = initialCountDownSeconds
       time?.invalidate()
       updateTimeLabel()
   }

   @objc func updateCountdown() {
       if countDownSeconds > 0 {
           countDownSeconds -= 1
           updateTimeLabel()
       } else {
           pauseTimer()
           // Таймер завершен, выполните необходимые действия
       }
   }


    
    // MARK: - UIPickerViewDataSource and UIPickerViewDelegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? 24 : 60
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(format: "%2d", row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateTimerLabelFromPicker()
    }
    
    
    
}
