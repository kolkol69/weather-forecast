//
//  ViewController.swift
//  kolkol_weather
//
//  Created by Student on 16/10/2019.
//  Copyright © 2019 mkolodiy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var CityLbl: String = ""
    var CityLon: Double = 0.0
    var CityLat: Double = 0.0
    
    private var dayNumber = 0;
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var MyName: UILabel!
    @IBOutlet weak var Condition: UILabel!
    @IBOutlet weak var Wind: UILabel!
    @IBOutlet weak var WeatherType: UILabel!
    @IBOutlet weak var Pressure: UILabel!
    @IBOutlet weak var MaxTemp: UILabel!
    @IBOutlet weak var MinTemp: UILabel!
    @IBOutlet weak var PrevDayButton: UIButton!
    @IBOutlet weak var NextDayButton: UIButton!
    @IBAction func btnShowOnMap(_ sender: Any) {
//        let vc = MapController()
//        vc.latt = self.CityLat
//        vc.long = self.CityLon
//
//        navigationController?.pushViewController(vc, animated: true)
    }
    
    func getDayNumber() -> Int{
        return self.dayNumber;
    }
    
    func setDayNumber(dayNumber: Int){
        self.dayNumber = dayNumber
    }
    
    func nextDay(){
        let dayNumber = getDayNumber();
        if self.dayNumber < 6 {
            setDayNumber(dayNumber: dayNumber + 1)
            fetchData()
        } else {
            self.disableButton(button: self.NextDayButton)
        }
        self.enableButton(button: self.PrevDayButton)
    }
    
    func prevDay(){
        let dayNumber = getDayNumber();
        if self.dayNumber > 0 {
            setDayNumber(dayNumber: dayNumber - 1)
            fetchData()
        }
        else {
            self.disableButton(button: self.PrevDayButton)
        }
        self.enableButton(button: self.NextDayButton)
    }
    
    func disableButton(button: UIButton){
        button.isEnabled = false
        button.alpha = 0.5
    }
    
    func enableButton(button: UIButton){
        button.isEnabled = true
        button.alpha = 1.0
    }
    
    @IBAction func NextDay(_ sender: UIButton) {
        self.nextDay()
    }
    
    @IBAction func PrevDay(_ sender: UIButton) {
        self.prevDay()
    }
    
    private let dataManager = DataManager(baseURL: API.AuthenticatedBaseURL)
    
    func fetchData() {
        var lat: Double
        var lon: Double
        if self.CityLat == 0.0 {
            lat = Defaults.Latitude
            self.CityLat = Defaults.Latitude
        } else {
            lat = self.CityLat
        }
        if self.CityLon == 0.0 {
            lon = Defaults.Longitude
            self.CityLon = Defaults.Longitude
        } else {
            lon = self.CityLon
        }
        dataManager.weatherDataForLocation(latitude: lat, longitude: lon) { (response, error) in

            var weatherData: WeatherData
            weatherData = WeatherData(data: response, dayNumber: self.getDayNumber())

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
        if self.CityLbl == "" {
            self.navigationItem.title = Defaults.City
        } else {
            self.navigationItem.title = self.CityLbl
        }
        self.styleHeader()
        MyName.text = "Maksym Kolodiy"
        self.disableButton(button: self.PrevDayButton)
        fetchData()
    }
    
    func styleHeader(){
        if let navController = self.navigationController {
            navController.navigationBar.isTranslucent = true
            navController.navigationBar.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            navController.navigationBar.alpha = 0.8
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is MapController
        {
            let vc = segue.destination as? MapController
            vc?.latt = self.CityLat
            vc?.long = self.CityLon
        }
    }
}
