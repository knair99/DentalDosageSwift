//
//  DentistTypeViewController.swift
//  Dental Dosage
//
//  Created by Karunakaran Prasad on 3/31/18.
//  Copyright © 2018 BayMonkeys. All rights reserved.
//

import UIKit

class DentistTypeViewController: UIViewController {
    
    //Create all locals here
    var dentistTypesArray : [DentistType] = []

    //Create all outlets here
    @IBOutlet weak var dentistTypeTableView: UITableView!
    
    //Create all actions here
    //Method to move the screen from current controller to next upon button press
    @IBAction func dentistTypeNextButtonPressed(_ sender: Any) {
        let parent = self.parent as! OnboardingViewController
        parent.moveNextController(currentViewController: self)
    }
    
    //Create all custom methods here
    func CreateDentistTypes () {
        dentistTypesArray.append(DentistType(dentistType: "General dentist", isSelected: false))
        dentistTypesArray.append(DentistType(dentistType: "Periodontist", isSelected: false))
        dentistTypesArray.append(DentistType(dentistType: "Oral surgeon", isSelected: false))
        dentistTypesArray.append(DentistType(dentistType: "Endodontist", isSelected: false))
        dentistTypesArray.append(DentistType(dentistType: "Prosthodontist", isSelected: false))
    }
    
    //Declare all overrides here
    override func viewDidLoad() {
        super.viewDidLoad()
        CreateDentistTypes()
        dentistTypeTableView.delegate = self
        dentistTypeTableView.dataSource = self
    }
}

//Need to set cell delegates for the view controller to implement (take action on)
extension DentistTypeViewController : OBDentistTypeCellDelegate {
    func didTapDentistTypeSwitch(dentistType: String) {
        print ("\(dentistType)")
    }
}

//Need to extend this class to accomodate a table view and its delegates
extension DentistTypeViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dentistTypesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dentist = dentistTypesArray[indexPath.item]
        let cell = dentistTypeTableView.dequeueReusableCell(withIdentifier: "DentistTypePrototypeCell") as! OBDentistTypeTableViewCell
        cell.setCell(dentistType: dentist.dentistType, isSelected: dentist.isSelected)
        
        //Set the cell delegate for the appropriate action on items in the cell
        cell.delegate = self
        
        return cell
    }
    
    
}
