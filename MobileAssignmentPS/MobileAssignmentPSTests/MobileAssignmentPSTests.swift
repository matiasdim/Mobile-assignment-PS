//
//  MobileAssignmentPSTests.swift
//  MobileAssignmentPSTests
//
//  Created by Matías Gil Echavarría on 10/6/20.
//  Copyright © 2020 Matías Gil Echavarría. All rights reserved.
//

import XCTest
@testable import MobileAssignmentPS

class MobileAssignmentPSTests: XCTestCase {
    
    /* ********* API Call ********* */

    func testLocationGet() {
        let e = expectation(description: "GetLocation")
        Location.getWeather(networkManager: NetworkManager(), lat: "4.09", lon: "-73.65", units: "metric", getForecast: false) { (location, error) in
            XCTAssertNotNil(location)
            e.fulfill()
        }
        wait(for: [e], timeout: 10.0)
    }
    
     /* ********* Model mapper - decoder ********* */
    
    let locationJSON = """
        {
        "coord": {
          "lon": -122.08,
          "lat": 37.39
        },
        "weather": [
          {
            "id": 800,
            "main": "Clear",
            "description": "clear sky",
            "icon": "01d"
          }
        ],
        "base": "stations",
        "main": {
          "temp": 282.55,
          "feels_like": 281.86,
          "temp_min": 280.37,
          "temp_max": 284.26,
          "pressure": 1023,
          "humidity": 100
        },
        "visibility": 16093,
        "wind": {
          "speed": 1.5,
          "deg": 350
        },
        "clouds": {
          "all": 1
        },
        "dt": 1560350645,
        "sys": {
          "type": 1,
          "id": 5122,
          "message": 0.0139,
          "country": "US",
          "sunrise": 1560343627,
          "sunset": 1560396563
        },
        "timezone": -25200,
        "id": 420006353,
        "name": "Mountain View",
        "cod": 200
        }
    """
    // Test Some ramdon location attributes Mapping
    
    func testNameMapLocation() {
        if let data: Data = locationJSON.data(using: .utf8) {
            do {
                let location = try JSONDecoder().decode(Location.self, from: data)
                XCTAssertEqual(location.name, "Mountain View")
            } catch {
                XCTFail()
            }
        } else {
            XCTFail()
        }
    }
    
    func testVisibilityMapLocation() {
        if let data: Data = locationJSON.data(using: .utf8) {
            do {
                let location = try JSONDecoder().decode(Location.self, from: data)
                XCTAssertEqual(location.visibility, 16093)
            } catch {
                XCTFail()
            }
        } else {
            XCTFail()
        }
    }
    
    func testTempMapLocation() {
        if let data: Data = locationJSON.data(using: .utf8) {
            do {
                let location = try JSONDecoder().decode(Location.self, from: data)
                XCTAssertEqual(location.temperature, 282.55)
            } catch {
                XCTFail()
            }
        } else {
            XCTFail()
        }
    }
    
    func testDescriptionMapLocation() {
        if let data: Data = locationJSON.data(using: .utf8) {
            do {
                let location = try JSONDecoder().decode(Location.self, from: data)
                XCTAssertEqual(location.feelsLike, 281.86)
            } catch {
                XCTFail()
            }
        } else {
            XCTFail()
        }
    }
    
    func testFeelsLikeMapLocation() {
        if let data: Data = locationJSON.data(using: .utf8) {
            do {
                let location = try JSONDecoder().decode(Location.self, from: data)
                XCTAssertEqual(location.temperature, 282.55)
            } catch {
                XCTFail()
            }
        } else {
            XCTFail()
        }
    }

}
