//
//  NetworkManager.swift
//  MobileAssignmentPS
//
//  Created by Matías Gil Echavarría on 10/6/20.
//  Copyright © 2020 Matías Gil Echavarría. All rights reserved.
//

import Foundation

struct Response {
    var data: Data?
    var networkError: Error?
    var customError: String?
}

struct NetworkManager {
    let baseURL = "https://api.openweathermap.org/data/2.5/"
    let apiKey = "c6e381d8c7ff98f0fee43775817cf6ad"
    
    // Generic GET API call
    private func getCall(url: URL, completionHandler: @escaping (Response) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completionHandler(Response(data: data, networkError: error, customError: nil))
        }.resume()
    }
    
    func getWeather(lat: String, lon: String, units: String, getForecast: Bool, completionHandler: @escaping (Response) -> ()) {
        let queryString = "?lat=\(lat)&lon=\(lon)&appid=\(self.apiKey)&units=\(units)"
        // If get Forecast true, we want forecast insted of current day weather
        if let url = URL(string: "\(baseURL)\(getForecast ? "forecast" : "weather")\(queryString)") {
            self.getCall(url: url, completionHandler: completionHandler)
        } else {
            completionHandler(Response(data: nil, networkError: nil, customError: "Bad URL construction."))
        }
    }
}
