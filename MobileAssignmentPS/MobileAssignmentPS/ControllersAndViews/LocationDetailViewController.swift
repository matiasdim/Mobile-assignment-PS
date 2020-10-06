//
//  LocationDetailViewController.swift
//  MobileAssignmentPS
//
//  Created by Matías Gil Echavarría on 10/6/20.
//  Copyright © 2020 Matías Gil Echavarría. All rights reserved.
//

import UIKit

class LocationDetailViewController: UIViewController {
    
    let location: Location
    @IBOutlet weak var temperatureLabel: UILabel!
    
    
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


  

}
