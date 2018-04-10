//
//  OBMetricTableViewCell.swift
//  Dental Dosage
//
//  Created by Karunakaran Prasad on 4/7/18.
//  Copyright © 2018 BayMonkeys. All rights reserved.
//

import UIKit

//Create protocol for interacting with components of cell
protocol OBMetricCellDelegate {
    
    //Need one method - To find if a switch is tapped on
    func didTapMetricSwitch (metricChosen: String)
}

class OBMetricTableViewCell: UITableViewCell {

    //Declare all outlets here
    @IBOutlet weak var metricUISwitch: UISwitch!
    @IBOutlet weak var metricUILabel: UILabel!
    
    //Declare all locals here
    var delegate: OBMetricCellDelegate?
    
    //Declare all actions here
    @IBAction func didTapMetricSwitch(_ sender: Any) {
        if metricUISwitch.isOn {
            delegate?.didTapMetricSwitch(metricChosen: metricUILabel.text!)
        }
    }
    
    //Declare custom methods here
    //Used from view controller to dynamically set the cell to view
    func setCell(metricLabel: String, isSelected: Bool){
        metricUILabel.text = metricLabel
        metricUISwitch.isOn = isSelected
    }
}
