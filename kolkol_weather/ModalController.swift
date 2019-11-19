//
//  ModalController.swift
//  
//
//  Created by Maksym Kolodiy on 09/11/2019.
//

import UIKit
import Foundation
import Alamofire
import CoreLocation
import DropDown

class ModalController: UIViewController, CLLocationManagerDelegate {
    
    var delegate = self
    var searchCity: String = ""
    var searchCoords: String = ""
    var searchField: String = "London"
    var searchResults: [[String: Any]] = []
    
    let locationManager = CLLocationManager()
    let dropDown = DropDown()
    
    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var txtSearchField: UITextField!
    @IBAction func btnGetMyLocation(_ sender: Any) {
        self.getLocation()
        self.btnCancel.sendActions(for: .touchUpInside)
    }
    @IBAction func btnSearch(_ sender: Any) {
        let url = "https://www.metaweather.com/api/location/search/?query=\(self.searchField)"
        AF.request(url, method: .get).responseJSON { response in
            if let result = response.value{
                if let cityArray = result as? [[String : Any]] {
                    if cityArray.count > 0 {
                        if let firstCity = cityArray.first {
                            self.getCityData(firstCity: firstCity)
                        }
                    } else {
                        self.showAlert(title: "City wasn't found", message: "Make sure there are no typoes or search for another city")
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtSearchField.addTarget(self, action: #selector(ModalController.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        self.getLocation()
        self.setupDropdown()
    }
    
    func setupDropdown(){
        dropDown.anchorView = txtField
        dropDown.direction = .bottom
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.searchField = item
            let city = self.findCityDataByName(cityName: item)
            self.getCityData(firstCity: city)
        }
    }
    
    func getCityData(firstCity: [String: Any]){
        if let coords = firstCity["latt_long"] as? String {
            self.searchCoords = coords
        }
        if let city = firstCity["title"] as? String {
            self.searchCity = city
        }
        self.btnCancel.sendActions(for: .touchUpInside)
    }
    
    func findCityDataByName(cityName: String) -> Dictionary<String, Any> {
        for city in self.searchResults {
            if let name: String = city["title"] as? String {
                if name == cityName {
                    return city
                }
            }
        }
        return ["": ""]
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            
            let longitude = String(location.coordinate.longitude)
            let latitude = String(location.coordinate.latitude)
            
            self.searchCoords = "\(latitude),\(longitude)"
            
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if (error != nil){
                    print("error in reverseGeocode")
                }
                let placemark = placemarks! as [CLPlacemark]
                if placemark.count>0{
                    let placemark = placemarks![0]
                    self.txtField.placeholder = "You are in \(placemark.locality!)"
                    self.searchCity = placemark.locality!
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        self.showAlert(title: "Location unavailable", message: "Please check if location service is enabled")
    }
    
    func getLocation(){
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        dropDown.reloadAllComponents()
        if let searchField = textField.text {
            self.searchField = searchField
        }
        let url = "https://www.metaweather.com/api/location/search/?query=\(self.searchField)"
        AF.request(url, method: .get).responseJSON { response in
            if let result = response.value{
                if let cityArray = result as? [[String : Any]] {
                    self.searchResults = cityArray
                    var dropDownArray: [String] = []
                    for city in cityArray {
                        if let cityName = city["title"] {
                            dropDownArray.append(cityName as! String)
                        }
                    }
                    self.dropDown.dataSource = dropDownArray
                    self.dropDown.show()
                }
            }
        }
        
    }
}
