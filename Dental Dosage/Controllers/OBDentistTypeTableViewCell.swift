//
//  OBDentistTypeTableViewCell.swift
//  Dental Dosage
//
//  Created by Karunakaran Prasad on 4/6/18.
//  Copyright © 2018 BayMonkeys. All rights reserved.
//

import UIKit

//Create protocol for interacting with components of cell
protocol OBDentistTypeCellDelegate {
    
    //Need one method - To find if a switch is tapped on
    func didTapDentistTypeSwitch (dentistType: String)
}


//Holds and controls two items in the prototype cell - the uiswitch and the label
class OBDentistTypeTableViewCell: UITableViewCell {
    
    //Declare all locals here
    //A delegate is needed to set actions from view cell
    var delegate: OBDentistTypeCellDelegate?
    
    //Declare all outlets here
    @IBOutlet weak var dentistTypeSwitch: UISwitch!
    @IBOutlet weak var dentistTypeLabel: UILabel!
    
    //Declare all actions here
    
    //When a switch is tapped, a delegate method at the table level needs to be fired
    @IBAction func dentistTypeSwitchTapped(_ sender: Any) {
       //We only need to call a delegate to action if the button is ON
        if dentistTypeSwitch.isOn {
        delegate?.didTapDentistTypeSwitch(dentistType: dentistTypeLabel.text!)
        }
    }
    
    //Declare all custom methods here
    //Used from view controller to dynamically set the cell to view
    func setCell(dentistType: String, isSelected: Bool){
        dentistTypeSwitch.isOn = isSelected
        dentistTypeLabel.text = dentistType
    }
    
    
    
}
