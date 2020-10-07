//
//  LocationTableViewCell.swift
//  MobileAssignmentPS
//
//  Created by Matías Gil Echavarría on 10/6/20.
//  Copyright © 2020 Matías Gil Echavarría. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    @IBOutlet weak var pinImage: UIImageView!
    @IBOutlet weak var coordinatesLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var locationNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.temperatureLabel.backgroundColor = .systemGray4
        self.temperatureLabel.circleShape()
        self.temperatureLabel.textColor = .black
        
        self.selectionStyle = .none
        
        self.locationNameLabel.adjustsFontSizeToFitWidth = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
