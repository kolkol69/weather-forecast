//
//  TableViewController.swift
//  kolkol_weather
//
//  Created by Maksym Kolodiy on 30/10/2019.
//  Copyright © 2019 mkolodiy. All rights reserved.
//

import UIKit
import CoreData


class TableViewController: UITableViewController {
    private let dataManager = DataManager(baseURL: API.AuthenticatedBaseURL)
    
    var cityDict: [String: String] = ["Lisbon" : "38.736946,-9.142685", "Warsaw": "52.237049,21.017532", "Kyiv": "50.450001,30.523333"]
    var deleteCityName: String? = ""
    var deleteRowIndexPaths: IndexPath? = nil
    
    @IBAction func AddCityBtn(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "background"))
        self.getCitiesFromCoreData()
        
    }
    
    func deleteAllCoreData(entity: String){

        let appDel:AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let context:NSManagedObjectContext = appDel.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "City")
            fetchRequest.returnsObjectsAsFaults = false
        do
        {
            let results = try context.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                context.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Deleted all my data in City error : \(error) \(error.userInfo)")
        }
    }
    
    func addCitiesToCoreData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "City", in: context)

        for (key, value) in cityDict {
           let newCity = NSManagedObject(entity: entity!, insertInto: context)
           newCity.setValue(key, forKey: "name")
           newCity.setValue(value, forKey: "location")
        }

        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
               
    }
    
    func getCitiesFromCoreData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "City")
        let context = appDelegate.persistentContainer.viewContext
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let name = data.value(forKey: "name") as! String
                let location = data.value(forKey: "location") as! String
                cityDict["\(name)"] = "\(location)"
          }
        } catch {
            print("Failed")
        }
        
        self.tableView.reloadData()
    }
    
    
    func fetchWeather(lat: Double, lon: Double, cell: TableViewCell){
        dataManager.weatherDataForLocation(latitude: lat, longitude: lon) { (response, error) in
            var weatherData: WeatherData
            
            weatherData = WeatherData(data: response, dayNumber: 0)
            
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
        cell.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        
        let cityArray = Array(cityDict)
        cell.lblCity.text = cityArray[indexPath.row].key
        
        let cityLocation = cityArray[indexPath.row].value.split{$0 == ","}.map(String.init)
        let Lat = Double(cityLocation[0])!
        let Lon = Double(cityLocation[1])!
        
        self.fetchWeather(lat: Lat, lon: Lon, cell: cell)
        
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        let cityArray = Array(cityDict)
        let cityLocation = cityArray[indexPath.row].value.split{$0 == ","}.map(String.init)
        vc.CityLbl = "\(cityArray[indexPath.row].key)"
        vc.CityLat = Double(cityLocation[0])!
        vc.CityLon = Double(cityLocation[1])!
        splitViewController?.showDetailViewController(vc, sender: nil)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let cityArray = Array(cityDict)
            let cityToDelete = cityArray[indexPath.row]
            self.deleteRowIndexPaths = indexPath
            self.deleteCityName = cityToDelete.key
            self.confirmDelete(name: cityToDelete.key)
        }
    }
    
    func confirmDelete(name: String) {
        let alert = UIAlertController(title: "Delete City", message: "Are you sure you want to permanently delete \(name)?", preferredStyle: .actionSheet)

        let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: self.handleDeleteCity)
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: self.cancelDeleteCity)

        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)

        self.present(alert, animated: true, completion: nil)
    }
    
    func handleDeleteCity(alertAction: UIAlertAction!) -> Void {
        if let deleteCity = deleteCityName {
            tableView.beginUpdates()
            
            cityDict.removeValue(forKey: deleteCity)

            // Note that indexPath is wrapped in an array:  [indexPath]
            if let indexPath = deleteRowIndexPaths {
                tableView.deleteRows(at: [(indexPath as IndexPath)], with: .automatic)
            }

            self.deleteCityName = ""

            tableView.endUpdates()
            self.updateCoreData()
        }
    }

    func cancelDeleteCity(alertAction: UIAlertAction!) {
        self.deleteCityName = ""
    }
    
    func updateCoreData(){
        self.deleteAllCoreData(entity: "City")
        self.addCitiesToCoreData()
        self.tableView.reloadData()
    }
    
    @IBAction func unwindToViewController(segue: UIStoryboardSegue) {
        print("seque", segue)
        let source = segue.source as? ModalController // This is the source
        if source?.searchCity != "" && source?.searchCoords != "" {
            let cityName = source?.searchCity
            let cityCoords = source?.searchCoords
            self.cityDict["\(cityName!)"] = cityCoords
            self.updateCoreData()
        }
    }
    
}
