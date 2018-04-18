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
        //Move to next view controller
        let parent = self.parent as! OnboardingViewController
        parent.moveNextController(currentViewController: self)
    }
    
    //Create all custom methods here
    func CreateDentistTypes () {
        //"dentist_types": ["general", "omfs", "pedo", "perio", "prostho", "endo", "oral_path"]
        dentistTypesArray.append(DentistType(dentistType: "General dentist", isSelected: false, key: "general"))
        dentistTypesArray.append(DentistType(dentistType: "Orthodontist", isSelected: false, key: "ortho"))
        dentistTypesArray.append(DentistType(dentistType: "Periodontist", isSelected: false, key: "perio"))
        dentistTypesArray.append(DentistType(dentistType: "Oral & Maxillofacial Surgeon", isSelected: false, key: "omfs"))
        dentistTypesArray.append(DentistType(dentistType: "Oral & Maxillofacial Pathologist", isSelected: false, key: "oral_path"))
        dentistTypesArray.append(DentistType(dentistType: "Endodontist", isSelected: false, key: "endo"))
        dentistTypesArray.append(DentistType(dentistType: "Prosthodontist", isSelected: false, key: "prostho"))
    }
    
    //Declare all overrides here
    override func viewDidLoad() {
        super.viewDidLoad()
        //Create all dentist types in array
        CreateDentistTypes()
        
        //Set the source and delegates to view controller's
        dentistTypeTableView.delegate = self
        dentistTypeTableView.dataSource = self
    }
}

//Need to set cell delegates for the view controller to implement (take action on)
extension DentistTypeViewController : OBDentistTypeCellDelegate {
    func didTapDentistTypeSwitch(dentistType: String) {
        let parent = self.parent as! OnboardingViewController
        parent.userSettings.setTypes(dentistType: dentistType)
    }
    
    func updateSwitchState(indexPath: IndexPath, isSelected: Bool) {
        let dentist = dentistTypesArray[indexPath.item]
        dentist.isSelected = isSelected
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
