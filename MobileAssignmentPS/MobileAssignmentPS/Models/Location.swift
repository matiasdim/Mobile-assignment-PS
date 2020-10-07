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
    var lat: String
    var long: String
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
    
    static func getWeather(networkManager: NetworkManager, lat: String, lon: String, units: String, getForecast: Bool, completionHandler: @escaping (Location?, ErrorString?) -> ()) {
        networkManager.getWeather(lat: lat, lon: lon, units: units, getForecast: getForecast) { (response) in
            if let data = response.data {
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let dictionaryResponse = json as? [String: Any] {
                        print(")")
//MAP CODINGKEYS!!!!
//                        Location(lat: lat, long: lon, weatherDescription: weatherDescription, temperature: <#T##Double#>, feelsLike: <#T##Double#>, minTemp: <#T##Double#>, maxTemp: <#T##Double#>, pressure: <#T##Int#>, humidity: <#T##Double#>, visibility: <#T##Double#>, windSpeed: <#T##Double#>, clouds: <#T##Double#>, sunriseTime: <#T##Int#>, sunsetTime: <#T##Int#>, name: <#T##String#>)
                        completionHandler(Location(lat: "5.811651034173423", long: "-74.03015179965784", weatherDescription: "Cloudy", temperature: 20, feelsLike: 22, minTemp: 18, maxTemp: 24, pressure: 1999, humidity: 39, visibility: 199, windSpeed: 12, clouds: 2, sunriseTime: 2123123, sunsetTime: 213123, name: "Medellin"), nil)
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
