//
//  ViewController.swift
//  kolkol_weather
//
//  Created by Student on 16/10/2019.
//  Copyright © 2019 mkolodiy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private var dayNumber = 0;
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var MyName: UILabel!
    @IBOutlet weak var Condition: UILabel!
    @IBOutlet weak var Wind: UILabel!
    @IBOutlet weak var WeatherType: UILabel!
    @IBOutlet weak var Pressure: UILabel!
    @IBOutlet weak var MaxTemp: UILabel!
    @IBOutlet weak var MinTemp: UILabel!
    
    func getDayNumber() -> Int{
        return self.dayNumber;
    }
    
    func setDayNumber(dayNumber: Int){
        self.dayNumber = dayNumber
    }
    
    func nextDay(){
        let dayNumber = getDayNumber();
        if self.dayNumber < 2 {
            setDayNumber(dayNumber: dayNumber + 1)
            fetchData()
        }
    }
    
    func prevDay(){
        let dayNumber = getDayNumber();
        if self.dayNumber > 0 {
            setDayNumber(dayNumber: dayNumber - 1)
            fetchData()
        }
    }
    
    @IBAction func NextDay(_ sender: UIButton) {
        self.nextDay()
        print("day: ", getDayNumber())
    }
    
    @IBAction func PrevDay(_ sender: UIButton) {
        self.prevDay()
        print("day: ", getDayNumber())
    }
    
    private let dataManager = DataManager(baseURL: API.AuthenticatedBaseURL)
    
    func fetchData() {
        dataManager.weatherDataForLocation(latitude: Defaults.Latitude, longitude: Defaults.Longitude) { (response, error) in

            var weatherData: WeatherData
            weatherData = WeatherData(data: response, dayNumber: self.getDayNumber())
            print("weatherData", weatherData.data)

                DispatchQueue.main.async {
                    self.Wind.text = "\(weatherData.wind)"
                    self.MaxTemp.text = "\(weatherData.maxTemp)"
                    self.MinTemp.text = "\(weatherData.minTemp)"
                    self.Pressure.text = "\(weatherData.pressure)"
                    self.WeatherType.text = "\(weatherData.precipType)"
                    self.Condition.text = "\(weatherData.description)"
                    self.weatherIcon.image = UIImage(named: "\(weatherData.icon)")
                }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MyName.text = "Maksym Kolodiy"
        fetchData()
        
    }
}
