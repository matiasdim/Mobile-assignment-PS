//
//  Extras.swift
//  MobileAssignmentPS
//
//  Created by Matías Gil Echavarría on 10/6/20.
//  Copyright © 2020 Matías Gil Echavarría. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    func circleShape(){
        self.layer.cornerRadius = self.bounds.height/2
        self.layer.masksToBounds = true
    }
}
