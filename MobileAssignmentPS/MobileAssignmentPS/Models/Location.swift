//
//  Location.swift
//  MobileAssignmentPS
//
//  Created by Matías Gil Echavarría on 10/6/20.
//  Copyright © 2020 Matías Gil Echavarría. All rights reserved.
//

import Foundation

enum ErrorString: String {
    case dataParsingError = "Data parsing Failed. Please tryagain."
    case requestError = "A network request error occurred. Please tryagain."
    case requestConstructionError = "An error occurred building the request. Please tryagain."
}

struct Location: Codable {
    var lat: Double
    var long: Double
    var weatherDescription: String
    var temperature: Double
    var feelsLike: Double
    var minTemp: Double
    var maxTemp: Double
    var pressure: Int
    var humidity: Double // %
    var visibility: Double
    var windSpeed: Double
    var clouds: Double // %
    var sunriseTime: Int
    var sunsetTime: Int
    var name: String
    
    static func getWeather(networkManager: NetworkManager, lat: String, lon: String, units: String, getForecast: Bool, completionHandler: @escaping (Dictionary<String, Any>?, ErrorString?) -> ()) {
        networkManager.getWeather(lat: lat, lon: lon, units: units, getForecast: getForecast) { (response) in
            if let data = response.data {
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let dictionaryResponse = json as? [String: Any] {
                        completionHandler(dictionaryResponse, nil)
                    } else {
                        completionHandler(nil, ErrorString.dataParsingError)
                    }
                } catch {
                    completionHandler(nil, ErrorString.dataParsingError)
                }
            } else if let _ = response.networkError {
                completionHandler(nil, ErrorString.requestError)
            } else {
                completionHandler(nil, ErrorString.requestConstructionError)
            }
            
            
        }
    }
}
