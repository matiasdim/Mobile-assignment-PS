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
    let dispatchGroup = DispatchGroup()
    let dispatchGroupCounter = 0
    
    var locations: [Location] = []
    let cellReuseIdentifier = "reuseIdentifier"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Locations"
        self.tableView.register(UINib(nibName: "LocationTableViewCell", bundle: nil), forCellReuseIdentifier: self.cellReuseIdentifier)
        
        let removeAllButton = UIBarButtonItem(title: "Remove All", style: .plain, target: self, action: #selector(self.removeAll))
        self.navigationItem.leftItemsSupplementBackButton = true
        self.navigationItem.leftBarButtonItem = removeAllButton
        
        if let persistedLocations = UserDefaults.standard.array(forKey: self.userDefaultsLocationKey), persistedLocations.count > 0 {
            
            for i in 0..<persistedLocations.count {
                if let persistedCoordinates = persistedLocations[i] as? [String: String], let lat = persistedCoordinates["lat"], let lon = persistedCoordinates["lon"] {
                    self.dispatchGroup.enter()
                    self.getweather(latitude: lat, longitude: lon, dispatchingGroup: true)
                }
            }
            dispatchGroup.notify(queue: .main) {
                //Stop indicator
                print("aa")
            }
        }
    }
    
    @objc func removeAll() {
        UserDefaults.standard.removeObject(forKey: self.userDefaultsLocationKey)
        self.locations = []
        UIView.animate(withDuration: 1, animations: {
            self.tableEmptyView.alpha = 1
        }) { (_) in
            self.tableView.reloadData()
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
    
    func removePersistedCoordinates(latitude: String, longitude: String) {
        let locationDict = ["lat": latitude, "lon": longitude]
        if var locations = UserDefaults.standard.array(forKey: self.userDefaultsLocationKey) as? [[String: String]] {
            var indexToRemove: Int?
            for (index, dict) in locations.enumerated() {
                if dict == locationDict {
                    indexToRemove = index
                    break
                }
            }
            if let indexToRemove = indexToRemove {
                locations.remove(at: indexToRemove)
                UserDefaults.standard.set(locations, forKey: self.userDefaultsLocationKey)
            }
        }
    }
    
    func getweather(latitude: String, longitude: String, dispatchingGroup: Bool) {
        Location.getWeather(networkManager: NetworkManager(), lat: latitude, lon: longitude, units: "metric", getForecast: false) { [weak self] (location, error) in
            if let location = location {
                self?.locations.append(location)
                DispatchQueue.main.async {
                    self?.tableEmptyView.alpha = 0
                    self?.tableView.reloadData()
                }
            } else {
                let alert = UIAlertController(title: "Error!", message: "\(error ?? "") Please try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                DispatchQueue.main.async {
                    self?.present(alert, animated: true, completion: nil)
                }
            }
            if dispatchingGroup {
                self?.dispatchGroup.leave()
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
            let locationToRemove = self.locations[indexPath.row]
            self.removePersistedCoordinates(latitude: "\(locationToRemove.lat)", longitude: "\(locationToRemove.lon)")
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
            cell.coordinatesLabel.text = "\(location.lat), \(location.lon)"
            cell.locationNameLabel.text = location.name
            cell.temperatureLabel.text = "\(location.temperature)"
            return cell
        }
        
        return UITableViewCell()
    }

}

extension RootViewController: BookmarkLocationDelegate {
    func addedLocation(latitude: String, longitude: String) {
        let lat = round(100*Double(latitude)!)/100
        let lon = round(100*Double(longitude)!)/100
        
        
        let roundedlatitude = String(format: "%.2f", lat)
        let roundedlongitude = String(format: "%.2f", lon)
        self.persistCoordinates(latitude: roundedlatitude, longitude: roundedlongitude)
        self.getweather(latitude: latitude, longitude: longitude, dispatchingGroup: false)
    }
}
