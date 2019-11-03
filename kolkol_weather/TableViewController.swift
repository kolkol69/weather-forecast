//
//  TableViewController.swift
//  kolkol_weather
//
//  Created by Maksym Kolodiy on 30/10/2019.
//  Copyright © 2019 mkolodiy. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var cityDict: [String: String] = ["Lisbon" : "38.736946,-9.142685", "Warsaw": "52.237049,21.017532", "Kyiv": "50.450001,30.523333"]

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cityDict.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // #warning Incomplete implementation, return the number of rows
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        //cell.lblText.text = "\(cityDict[indexPath.row])"
        let cityArray = Array(cityDict)
        cell.lblText.text = cityArray[indexPath.row].key
        //print("seleceted", indexPath)
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
