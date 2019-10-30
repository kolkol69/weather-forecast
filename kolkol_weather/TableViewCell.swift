//
//  TableViewCell.swift
//  kolkol_weather
//
//  Created by Maksym Kolodiy on 30/10/2019.
//  Copyright © 2019 mkolodiy. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var lblText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
