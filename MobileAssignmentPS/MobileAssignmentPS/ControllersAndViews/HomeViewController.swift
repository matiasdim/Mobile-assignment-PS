//
//  HomeViewController.swift
//  MobileAssignmentPS
//
//  Created by Matías Gil Echavarría on 10/6/20.
//  Copyright © 2020 Matías Gil Echavarría. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    var bookmarkedLocations: [Location] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
                            
        
    }

    // add location
    func addLocation () {
        Location.getWeather(networkManager: NetworkManager(), lat: "0", lon: "0", units: "metric", getForecast: false) { [weak self] (response, error) in
            if let response = response {
                
            } else {
                let alert = UIAlertController(title: "Error!", message: "\(error ?? ErrorString(rawValue: "Unknown error.")) Please try again", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                DispatchQueue.main.async {
                    self?.present(alert, animated: true, completion: nil)
                }
            }
        }
    }

}
