//
//  ActivityIndicatorViewController.swift
//  MobileAssignmentPS
//
//  Created by Matías Gil Echavarría on 10/7/20.
//  Copyright © 2020 Matías Gil Echavarría. All rights reserved.
//

import UIKit

class ActivityIndicatorViewController: UIViewController {
    
    var indicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = UIView()
        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        
        self.indicator.translatesAutoresizingMaskIntoConstraints = false
        self.indicator.startAnimating()
        self.view.addSubview(self.indicator)
        
        self.indicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.indicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true        
    }

}
