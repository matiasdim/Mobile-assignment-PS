//
//  AddLocationViewController.swift
//  MobileAssignmentPS
//
//  Created by Matías Gil Echavarría on 10/6/20.
//  Copyright © 2020 Matías Gil Echavarría. All rights reserved.
//

import UIKit
import MapKit

protocol BookmarkLocationDelegate: class {
    func addedLocation(latitude: String, longitude: String)
}

class AddLocationViewController: UIViewController, MKMapViewDelegate {
    
    //Default coordinate
    var selectedCoordinate: CLLocationCoordinate2D?
    weak var delegate: BookmarkLocationDelegate?
    @IBOutlet private var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.mapViewTapped))
        self.mapView.addGestureRecognizer(tapGesture)

    }
    
    @IBAction func close(_ sender: Any) {
        self.mapView.annotations.forEach{mapView.removeAnnotation($0)}
        self.dismiss(animated: true)
    }
    
    @IBAction func add(_ sender: Any) {
        if let coordinate = self.selectedCoordinate {
            self.delegate?.addedLocation(latitude: "\(coordinate.latitude)", longitude: "\(coordinate.longitude)")
            self.close(self)
        } else {
            let alert = UIAlertController(title: "Select location", message: "First, tap a place in the map to select a location", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true)
        }
        
    }
    @objc func mapViewTapped(gestureRecognizer: UIGestureRecognizer) {
        let touchPoint = gestureRecognizer.location(in: self.mapView)
        let coordinate = self.mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
        self.selectedCoordinate = coordinate
        self.addPin(coordiante: coordinate)
    }
    
    func addPin(coordiante: CLLocationCoordinate2D) {
        self.mapView.annotations.forEach{ self.mapView.removeAnnotation($0) }
        let newAnnotation = MKPointAnnotation()
        newAnnotation.coordinate = coordiante

        self.mapView.addAnnotation(newAnnotation)
    }
}
