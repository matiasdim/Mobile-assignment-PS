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
    
    let indicatorVC = ActivityIndicatorViewController()
    let searchController = UISearchController(searchResultsController: nil)
    var filteredLocations: [Location] = []
    var isSearchBarEmpty: Bool {
      return self.searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return self.searchController.isActive && !self.isSearchBarEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Locations"
        self.tableView.register(UINib(nibName: "LocationTableViewCell", bundle: nil), forCellReuseIdentifier: self.cellReuseIdentifier)

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Help", style: .plain, target: self, action: #selector(self.openHelp))
        let removeAllButton = UIBarButtonItem(title: "Remove All", style: .plain, target: self, action: #selector(self.removeAll))
        self.navigationItem.leftItemsSupplementBackButton = true
        self.navigationItem.leftBarButtonItem = removeAllButton
        
        if #available(iOS 11.0, *) {
            self.searchController.searchResultsUpdater = self
            self.searchController.obscuresBackgroundDuringPresentation = false
            self.searchController.searchBar.placeholder = "Search Locations"
            self.navigationItem.searchController = self.searchController
            self.definesPresentationContext = true
            self.navigationItem.hidesSearchBarWhenScrolling = true
        }
        if let persistedLocations = UserDefaults.standard.array(forKey: self.userDefaultsLocationKey), persistedLocations.count > 0 {
            
            for i in 0..<persistedLocations.count {
                if let persistedCoordinates = persistedLocations[i] as? [String: String], let lat = persistedCoordinates["lat"], let lon = persistedCoordinates["lon"] {
                    self.dispatchGroup.enter()
                    self.getweather(latitude: lat, longitude: lon, dispatchingGroup: true)
                }
            }
        }
    }
    
    @objc func openHelp() {
        self.present(HelpViewController(), animated: true)
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    @IBAction func addLocation(_ sender: Any) {
        let addLocationViewController = AddLocationViewController()
        addLocationViewController.delegate = self
        self.present(addLocationViewController, animated: true)
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
        self.addActivityIndicator()
        Location.getWeather(networkManager: NetworkManager(), lat: latitude, lon: longitude, units: "metric", getForecast: false) { [weak self] (location, error) in
            self?.removectivityIndicator()
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
                    self?.present(alert, animated: true)
                }
            }
            if dispatchingGroup {
                self?.dispatchGroup.leave()
            }
        }
    }
    
    func addActivityIndicator() {
        self.addChild(self.indicatorVC)
        self.indicatorVC.view.frame = self.view.frame
        self.view.addSubview(self.indicatorVC.view)
        self.indicatorVC.didMove(toParent: self)
    }
    
    func removectivityIndicator() {
        DispatchQueue.main.async {
            self.indicatorVC.willMove(toParent: nil)
            self.indicatorVC.view.removeFromSuperview()
            self.indicatorVC.removeFromParent()
        }
    }
    
    func filterContentForSearchText(_ searchText: String) {
        self.filteredLocations = self.locations.filter { (location: Location) -> Bool in
            return location.name.lowercased().contains(searchText.lowercased())
        }
        self.tableView.reloadData()
    }
}


extension RootViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let locations: [Location]
        if self.isFiltering {
            locations = self.filteredLocations
        } else {
            locations = self.locations
        }
        self.navigationController?.pushViewController(LocationDetailViewController(location: locations[indexPath.row]), animated: true)
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
        if self.isFiltering {
            return self.filteredLocations.count
        }
        return self.locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifier, for: indexPath) as? LocationTableViewCell {
            let location: Location
            if self.isFiltering {
                location = self.filteredLocations[indexPath.row]
            } else {
                location = self.locations[indexPath.row]
            }
            
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

extension RootViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        self.filterContentForSearchText(searchBar.text!)
    }
    
    
}
