//
//  ModalController.swift
//  
//
//  Created by Maksym Kolodiy on 09/11/2019.
//

import UIKit
import Foundation
import Alamofire

class ModalController: UIViewController {
    var delegate = self
    var searchCity: String = ""
    var searchCoords: String = ""
    var searchField: String = "London"
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var txtSearchField: UITextField!
    @IBAction func btnSearch(_ sender: Any) {
        print("search")
        let url = "https://www.metaweather.com/api/location/search/?query=\(self.searchField)"
        AF.request(url, method: .get).responseJSON { response in
            if let result = response.value{
                if let cityArray = result as? [[String : Any]] {
                    //print(cityArray, cityArray.count)
                    if cityArray.count > 0 {
                        self.getCityData(cityArray: cityArray)
                    } else {
                        //print("No such city, try another one pls")
                        self.showAlert()
                    }
                }
            }
        }
    }
    
    func getCityData(cityArray: [[String: Any]]){
        if let firstCity = cityArray.first {
            if let coords = firstCity["latt_long"] as? String {
                self.searchCoords = coords
            }
            if let city = firstCity["title"] as? String {
                self.searchCity = city
            }
            
//            print(self.searchCity)
//            print(self.searchCoords)
            self.btnCancel.sendActions(for: .touchUpInside)
            //self.dismiss(animated: true, completion: nil)
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "City wasn't found", message: "Make sure there are no typoes or search for another city", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

        self.present(alert, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtSearchField.addTarget(self, action: #selector(ModalController.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        // Do any additional setup after loading the view.
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
//        print("hit: ", textField.text)
        if let searchField = textField.text {
//            print(searchField)
            self.searchField = searchField
        }

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
