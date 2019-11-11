//
//  TableViewController.swift
//  kolkol_weather
//
//  Created by Maksym Kolodiy on 30/10/2019.
//  Copyright © 2019 mkolodiy. All rights reserved.
//

import UIKit
class TableViewController: UITableViewController {
    private let dataManager = DataManager(baseURL: API.AuthenticatedBaseURL)
    var cityDict: [String: String] = ["Lisbon" : "38.736946,-9.142685", "Warsaw": "52.237049,21.017532", "Kyiv": "50.450001,30.523333"]
    @IBAction func AddCityBtn(_ sender: Any) {
        
        print("Add")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "background"))
    }
    
    func fetchWeather(lat: Double, lon: Double, cell: TableViewCell){
        dataManager.weatherDataForLocation(latitude: lat, longitude: lon) { (response, error) in
            var weatherData: WeatherData
            
            weatherData = WeatherData(data: response, dayNumber: 0)
            print(weatherData.currentlyIcon)
            
                DispatchQueue.main.async {
                    cell.lblTemp.text = weatherData.currentlyTemp
                    cell.imgWeatherIcon.image = UIImage(named: weatherData.currentlyIcon)
                }
        }
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cityDict.count
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(white: 1, alpha: 0.5)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        
        let cityArray = Array(cityDict)
        cell.lblCity.text = cityArray[indexPath.row].key
        
        var cityLocation = cityArray[indexPath.row].value.split{$0 == ","}.map(String.init)
        let Lat = Double(cityLocation[0])!
        let Lon = Double(cityLocation[1])!
        
        self.fetchWeather(lat: Lat, lon: Lon, cell: cell)
        
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        let cityArray = Array(cityDict)
        var cityLocation = cityArray[indexPath.row].value.split{$0 == ","}.map(String.init)
        vc.CityLbl = "\(cityArray[indexPath.row].key)"
        vc.CityLat = Double(cityLocation[0])!
        vc.CityLon = Double(cityLocation[1])!
        splitViewController?.showDetailViewController(vc, sender: nil)
    }

}
