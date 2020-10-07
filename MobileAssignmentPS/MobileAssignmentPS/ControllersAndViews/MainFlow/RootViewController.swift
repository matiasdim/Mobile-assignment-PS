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
    @IBOutlet weak var tableEmptyView: UIView!
    let userDefaultsLocationKey = "locations"
    
    var locations: [Location] = []
    let cellReuseIdentifier = "reuseIdentifier"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Locations"
        self.tableView.register(UINib(nibName: "LocationTableViewCell", bundle: nil), forCellReuseIdentifier: self.cellReuseIdentifier)
        
        if let persistedLocations = UserDefaults.standard.array(forKey: self.userDefaultsLocationKey), persistedLocations.count > 0 {
            print("")
            // Pull fromapi each coordinated saved in UD
            if let test = persistedLocations as? [[String:String]] {
                self.getweather(latitude: test.first!["lat"]!, longitude: test.first!["lon"]!)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableEmptyView.alpha = self.locations.isEmpty ? 1 : 0
    }

    @IBAction func addLocation(_ sender: Any) {
        let addLocationViewController = AddLocationViewController()
        addLocationViewController.delegate = self
        self.present(addLocationViewController, animated: true, completion: nil)
    }
    
    func persistCoordinates(latitude: String, longitude: String) {
        let locationDict = ["lat": latitude, "lon": longitude]
        if var locations = UserDefaults.standard.array(forKey: self.userDefaultsLocationKey) {
            locations.append(locationDict)
            UserDefaults.standard.set(locations, forKey: self.userDefaultsLocationKey)
        } else {
            let bookMarkedLocations = [locationDict]
            UserDefaults.standard.set(bookMarkedLocations, forKey: self.userDefaultsLocationKey)
        }
    }
    
    func getweather(latitude: String, longitude: String) {
        Location.getWeather(networkManager: NetworkManager(), lat: latitude, lon: longitude, units: "metric", getForecast: false) { [weak self] (location, error) in
            if let location = location {
                self?.locations.append(location)
                DispatchQueue.main.async {
                    self?.tableEmptyView.alpha = 0
                    self?.tableView.reloadData()
                }
            } else {
                let alert = UIAlertController(title: "Error!", message: "\(String(describing: error ?? ErrorString(rawValue: "Unknown error."))) Please try again.", preferredStyle: .alert)
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.locations.remove(at: indexPath.row)
            if self.locations.isEmpty{
                UIView.animate(withDuration: 1, animations: {
                    self.tableEmptyView.alpha = 1
                }) { (_) in
                    self.tableView.reloadData()
                }
            } else {
                self.tableView.reloadData()
            }
            
        }
    }
}

extension RootViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locations.count
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

extension RootViewController: BookmarkLocationDelegate {
    func addedLocation(latitude: String, longitude: String) {
        self.persistCoordinates(latitude: latitude, longitude: longitude)
        self.getweather(latitude: latitude, longitude: longitude)
    }
}
