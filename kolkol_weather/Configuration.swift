//
//  Configuration.swift
//  kolkol_weather
//
//  Created by Student on 16/10/2019.
//  Copyright © 2019 mkolodiy. All rights reserved.
//

import Foundation

struct API {
    static let APIKey = "4f4244bc8ea63e0865f4f146b32fb69d"
    static let BaseUrl = URL(string: "https://api.darksky.net/forecast/")!
    
    static var AuthenticatedBaseURL: URL {
        return BaseUrl.appendingPathComponent(APIKey)
    }
}

struct Defaults {
    
    static let Latitude: Double = 50.064651
    static let Longitude: Double = 19.944981
}

