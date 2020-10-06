//
//  RootViewController.swift
//  MobileAssignmentPS
//
//  Created by Matías Gil Echavarría on 10/6/20.
//  Copyright © 2020 Matías Gil Echavarría. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var locations: [Location] = [Location(lat: 2, long: 1, weatherDescription: "Cloudy", temperature: 20, feelsLike: 22, minTemp: 18, maxTemp: 24, pressure: 1999, humidity: 39, visibility: 199, windSpeed: 12, clouds: 2, sunriseTime: 2123123, sunsetTime: 213123, name: "Medellin")]
    let cellReuseIdentifier = "reuseIdentifier"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Locations"
        self.tableView.register(UINib(nibName: "LocationTableViewCell", bundle: nil), forCellReuseIdentifier: self.cellReuseIdentifier)
    }

    // add location
    func addLocation () {
        Location.getWeather(networkManager: NetworkManager(), lat: "0", lon: "0", units: "metric", getForecast: false) { [weak self] (response, error) in
            if let response = response {
                
            } else {
                let alert = UIAlertController(title: "Error!", message: "\(String(describing: error ?? ErrorString(rawValue: "Unknown error."))) Please try again", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                DispatchQueue.main.async {
                    self?.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}


extension RootViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(LocationDetailViewController(location: self.locations[indexPath.row]), animated: true)
    }
}

extension RootViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifier, for: indexPath) as? LocationTableViewCell {
            let location = self.locations[indexPath.row]
            cell.coordinatesLabel.text = "Coordinates: \(location.lat), \(location.long)"
            cell.locationNameLabel.text = location.name
            cell.temperatureLabel.text = "\(location.temperature)"
            return cell
        }
        
        return UITableViewCell()
    }
    

}
