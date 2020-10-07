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




struct Location: Decodable {
    var lat: Double
    var lon: Double
    var weatherDescription: String
    var temperature: Double
    var feelsLike: Double
    var minTemp: Double
    var maxTemp: Double
    var pressure: Double
    var humidity: Double
    var visibility: Double
    var windSpeed: Double
    var clouds: Double
    var sunriseTime: Int
    var sunsetTime: Int
    var name: String
    
    private enum CodingKeys: String, CodingKey {
        case coord, weather, main, visibility, wind, clouds, sys, name

        enum Coord: String, CodingKey {
            case lat, lon
        }
        
        enum Weather: String, CodingKey {
            case weatherDescription = "description"
        }
        
        enum Main: String, CodingKey {
            case pressure, humidity, temperature = "temp", feelsLike = "feels_like",minTemp = "temp_min", maxTemp = "temp_max"
        }
        
        enum Wind: String, CodingKey {
             case windSpeed = "speed"
        }
        
        enum Clouds: String, CodingKey {
            case clouds = "all"
        }
        
        enum Sys: String, CodingKey {
            case sunriseTime = "sunrise"
            case sunsetTime = "sunset"
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.visibility = try container.decode(Double.self, forKey: .visibility)
        self.name = try container.decode(String.self, forKey: .name)
        
        let coord = try container.nestedContainer(keyedBy: CodingKeys.Coord.self, forKey: .coord)
        self.lat = try coord.decode(Double.self, forKey: .lat)
        self.lon = try coord.decode(Double.self, forKey: .lon)
       
        var weatherContainer = try container.nestedUnkeyedContainer(forKey: .weather)
        let firstWeatherDescription = try weatherContainer.nestedContainer(keyedBy: CodingKeys.Weather.self)
        self.weatherDescription = try firstWeatherDescription.decode(String.self, forKey: .weatherDescription)

        let main = try container.nestedContainer(keyedBy: CodingKeys.Main.self, forKey: .main)
        self.temperature = try main.decode(Double.self, forKey: .temperature)
        self.feelsLike = try main.decode(Double.self, forKey: .feelsLike)
        self.minTemp = try main.decode(Double.self, forKey: .minTemp)
        self.maxTemp = try main.decode(Double.self, forKey: .maxTemp)
        self.pressure = try main.decode(Double.self, forKey: .pressure)
        self.humidity = try main.decode(Double.self, forKey: .humidity)

        let wind = try container.nestedContainer(keyedBy: CodingKeys.Wind.self, forKey: .wind)
        self.windSpeed = try wind.decode(Double.self, forKey: .windSpeed)

        let clouds = try container.nestedContainer(keyedBy: CodingKeys.Clouds.self, forKey: .clouds)
        self.clouds = try clouds.decode(Double.self, forKey: .clouds)

        let sys = try container.nestedContainer(keyedBy: CodingKeys.Sys.self, forKey: .sys)
        self.sunriseTime = try sys.decode(Int.self, forKey: .sunriseTime)
        self.sunsetTime = try sys.decode(Int.self, forKey: .sunsetTime)
    }
    
    static func getWeather(networkManager: NetworkManager, lat: String, lon: String, units: String, getForecast: Bool, completionHandler: @escaping (Location?, String?) -> ()) {
        networkManager.getWeather(lat: lat, lon: lon, units: units, getForecast: getForecast) { (response) in
            if let data = response.data {
                do {
                    let location = try JSONDecoder().decode(Location.self, from: data)
                    completionHandler(location, nil)
                } catch {
                    completionHandler(nil, ErrorString.dataParsingError.rawValue)
                    print("error: ", error)
                }
            } else if let _ = response.networkError {
                completionHandler(nil, ErrorString.requestError.rawValue)
            } else {
                completionHandler(nil, ErrorString.requestConstructionError.rawValue)
            }


        }
    }

}
    
    
