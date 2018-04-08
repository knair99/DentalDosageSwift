//
//  OBMetricTableViewCell.swift
//  Dental Dosage
//
//  Created by Karunakaran Prasad on 4/7/18.
//  Copyright © 2018 BayMonkeys. All rights reserved.
//

import UIKit

class OBMetricTableViewCell: UITableViewCell {

    //Declare outlets here
    @IBOutlet weak var metricUISwitch: UISwitch!
    @IBOutlet weak var metricUILabel: UILabel!
    
    //Declare custom functions here
    func setCell(metricLabel: String, isSelected: Bool){
        metricUILabel.text = metricLabel
        metricUISwitch.isOn = isSelected
    }
}
