//
//  LocationDetailViewController.swift
//  MobileAssignmentPS
//
//  Created by Matías Gil Echavarría on 10/6/20.
//  Copyright © 2020 Matías Gil Echavarría. All rights reserved.
//

import UIKit
import MapKit

class LocationDetailViewController: UIViewController {
    
    enum InformationType {
        case temperature
        case humdity
        case pressure
        case wind
        case feelsLike
        case minMax
        case visibility
        case cloudy
        case sunTimes
        
    }
    
    let location: Location
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    let collectionCellReuseIdentifier = "collectionCellReuseIdentifier"
    let informationViews: [InformationType] = [.temperature, .humdity, .pressure, .wind, .feelsLike, .minMax, .visibility, .cloudy]
       
    init(location: Location) {
        self.location = location
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.location.name
        self.temperatureLabel.circleShape()
        self.temperatureLabel.backgroundColor = .systemGray4
        self.temperatureLabel.textColor = .black
        self.temperatureLabel.text = "\(self.location.temperature)"
        
        self.collectionView.register(UINib(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: self.collectionCellReuseIdentifier)
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.headerView.isHidden = UIDevice.current.orientation.isLandscape
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Little hack to get correct orientation in phone when the orintation has not changed since app started
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.headerView.isHidden = UIScreen.main.bounds.width > UIScreen.main.bounds.height
        }
        
        let lat = Double(self.location.lat)
        let lon = Double(self.location.long)
        
        let coordinates = CLLocationCoordinate2D(latitude:lat!, longitude:lon!)
        self.addPin(coordiante: coordinates)
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    func addPin(coordiante: CLLocationCoordinate2D) {
        let newAnnotation = MKPointAnnotation()
        newAnnotation.coordinate = coordiante

        self.mapView.addAnnotation(newAnnotation)
    }
}

extension LocationDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.informationViews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.collectionCellReuseIdentifier, for: indexPath) as? CustomCollectionViewCell {
            switch self.informationViews[indexPath.row] {
            case .pressure:
                cell.valueLabel.text = "\(self.location.pressure)"
                cell.titleLabel.text = "Pressure (hPa)"
            case .humdity:
                cell.valueLabel.text = "\(self.location.humidity)"
                cell.titleLabel.text = "Humidity (%)"
            case .temperature:
                cell.valueLabel.text = "\(self.location.temperature)"
                cell.titleLabel.text = "Temperature (Celsius)"
            case .wind:
                cell.valueLabel.text = "\(self.location.windSpeed)"
                cell.titleLabel.text = "Wind Speed (meter/sec)"
            case .feelsLike:
                cell.valueLabel.text = "\(self.location.feelsLike)"
                cell.titleLabel.text = "Feels Lile (Celsius)"
            case .minMax:
                cell.valueLabel.text = "\(self.location.minTemp)/\(self.location.maxTemp)"
                cell.titleLabel.text = "Min/Max Temp (Celsius)"
            case .visibility:
                cell.valueLabel.text = "\(self.location.visibility)"
                cell.titleLabel.text = "Visibility (meter)"
            case .cloudy:
                cell.valueLabel.text = "\(self.location.clouds)"
                cell.titleLabel.text = "Cluds (%)"
            case .sunTimes:
                cell.valueLabel.text = "\(self.location.sunriseTime)/\(self.location.sunsetTime)"
                cell.titleLabel.text = "Sunrise/Sunset (UTC)"
            }
            
            return cell
        }
        return UICollectionViewCell()
    }
        
}

extension LocationDetailViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {

        let totalCellWidth = 100 * self.informationViews.count
        let totalSpacingWidth = 10 * (self.informationViews.count - 1)

        let leftInset = (self.collectionView.bounds.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset

        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
    }
}
