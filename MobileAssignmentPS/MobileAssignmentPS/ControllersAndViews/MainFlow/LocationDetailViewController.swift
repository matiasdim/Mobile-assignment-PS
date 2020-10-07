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
    
    let location: Location
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var headerView: UIView!
    
    init(location: Location) {
        self.location = location
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.temperatureLabel.circleShape()
        self.temperatureLabel.backgroundColor = .systemGray4
        self.temperatureLabel.textColor = .black
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        self.headerView.isHidden = UIDevice.current.orientation.isLandscape
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.headerView.isHidden = UIDevice.current.orientation.isLandscape
        
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
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return UICollectionViewCell()
    }
    
    
}

extension LocationDetailViewController: UICollectionViewDelegate {
    
}
