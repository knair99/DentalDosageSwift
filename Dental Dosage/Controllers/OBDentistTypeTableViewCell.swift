//
//  OBDentistTypeTableViewCell.swift
//  Dental Dosage
//
//  Created by Karunakaran Prasad on 4/6/18.
//  Copyright © 2018 BayMonkeys. All rights reserved.
//

import UIKit

//Holds and controls two items in the prototype cell - the uiswitch and the label
class OBDentistTypeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dentistTypeSwitch: UISwitch!
    @IBOutlet weak var dentistTypeLabel: UILabel!
    
    //Used from view controller to dynamically set the cell to view
    func setCell(dentistType: String, isSelected: Bool){
        dentistTypeSwitch.isOn = isSelected
        dentistTypeLabel.text = dentistType
    }
    
}
