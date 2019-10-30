//
//  WeatherData.swift
//  kolkol_weather
//
//  Created by Student on 16/10/2019.
//  Copyright © 2019 mkolodiy. All rights reserved.
//

import Foundation
import SwiftyJSON

struct WeatherData {
    
    var maxTemp: String
    var minTemp: String
    var description: String
    var icon: String
    var precipType: String
    var pressure: String
    var wind: String
    var data: JSON
    
    init(data: Any, dayNumber: Int) {
        let json = JSON(data)
        let dailyWeather = json["daily"]

        if let dailyWeatherData = dailyWeather["data"].array {
            self.data = dailyWeatherData[dayNumber]
            print(self.data)
            if let summary = self.data["summary"].string {
                self.description = summary
            } else {
                self.description = "--"
            }
            
            if let icon = self.data["icon"].string {
                self.icon = icon
            } else {
                self.icon = "--"
            }
            
            if let maxTemp = self.data["temperatureMax"].float {
                self.maxTemp = String(format: "%.0f", (maxTemp - 32) * 5 / 9) + " ºC"
            } else {
                self.maxTemp = "--"
            }
            
            if let minTemp = self.data["temperatureMin"].float {
                self.minTemp = String(format: "%.0f", (minTemp - 32) * 5 / 9) + " ºC"
            } else {
                self.minTemp = "--"
            }
            
            if let precipType = self.data["precipProbability"].float {
                self.precipType = "\(precipType * 100) %"
            } else {
                self.precipType = "--"
            }
            
            if let pressure = self.data["pressure"].float {
                self.pressure = String(format: "%.0f", pressure) + " hPa"
            } else {
                self.pressure = "--"
            }
            
            if let wind = self.data["windSpeed"].float {
                self.wind = String(format: "%.0f", wind) + " m/s"
            } else {
                self.wind = "--"
            }
        } else {
            self.data = []
            self.description = "--"
            self.icon = "--"
            self.maxTemp = "--"
            self.minTemp = "--"
            self.precipType = "--"
            self.pressure = "--"
            self.wind = "--"
        }
        
    }
}
