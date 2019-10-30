//
//  TableViewController.swift
//  kolkol_weather
//
//  Created by Maksym Kolodiy on 30/10/2019.
//  Copyright © 2019 mkolodiy. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var arrData = [1,2,3]

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
        return arrData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // #warning Incomplete implementation, return the number of rows
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.lblText.text = "\(arrData[indexPath.row])"
        
        return cell;
    }

}
