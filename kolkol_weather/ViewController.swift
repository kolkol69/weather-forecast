//
//  ViewController.swift
//  kolkol_weather
//
//  Created by Student on 16/10/2019.
//  Copyright © 2019 mkolodiy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var MyName: UILabel!
    @IBOutlet weak var Condition: UILabel!
    @IBOutlet weak var Temp: UILabel!
    @IBOutlet weak var Wind: UILabel!
    @IBOutlet weak var Rain: UILabel!
    @IBOutlet weak var Pressure: UILabel!
    
    private let dataManager = DataManager(baseURL: API.AuthenticatedBaseURL)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        MyName.text = "Maksym Kolodiy"
        
        dataManager.weatherDataForLocation(latitude: Defaults.Latitude, longitude: Defaults.Longitude) { (response, error) in
            print("response \(response)")
            if let weatherData = WeatherData(JSON: response) {
                print("weatherData", weatherData)
                let windSpeed = String(weatherData.hourData[0].windSpeed)
                DispatchQueue.main.async {
                    self.Wind.text = "\(windSpeed) km/h"
                }
            }
        }
    }


}

