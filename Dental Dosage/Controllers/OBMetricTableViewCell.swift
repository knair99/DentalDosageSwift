//
//  OBMetricTableViewCell.swift
//  Dental Dosage
//
//  Created by Karunakaran Prasad on 4/7/18.
//  Copyright © 2018 BayMonkeys. All rights reserved.
//

import UIKit

class OBMetricTableViewCell: UITableViewCell {

    //Declare all outlets here
    @IBOutlet weak var metricUISwitch: UISwitch!
    @IBOutlet weak var metricUILabel: UILabel!
    
    //Declare custom methods here
    //Used from view controller to dynamically set the cell to view
    func setCell(metricLabel: String, isSelected: Bool){
        metricUILabel.text = metricLabel
        metricUISwitch.isOn = isSelected
    }
}
