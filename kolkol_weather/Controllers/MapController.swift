//
//  MapController.swift
//  kolkol_weather
//
//  Created by Maksym Kolodiy on 11/11/2019.
//  Copyright © 2019 mkolodiy. All rights reserved.
//

import UIKit
import MapKit

class MapController: UIViewController {
    var latt: Double = 0.0
    var long: Double = 0.0
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var btnBack: UIButton!
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let annotation = MKPointAnnotation()
        let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(self.latt), longitude: CLLocationDegrees(self.long))
        annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(self.latt), longitude: CLLocationDegrees(self.long))
        mapView.addAnnotation(annotation)
        //Center the map on the place location
        mapView.setCenter(location, animated: true)
    }
    
}
