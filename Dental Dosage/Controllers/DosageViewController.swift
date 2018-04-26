//
//  DosageViewController.swift
//  Dental Dosage
//
//  Created by Karunakaran Prasad on 4/18/18.
//  Copyright © 2018 BayMonkeys. All rights reserved.
//

import UIKit

class DosageViewController: UIViewController {
    
    //Declare all locals here
    //Header
    var drugName: String?
    var drugDetails : [String:Any]?
    //Inputs
    var patientWeight: Float = 0
    var dosageAmount: Float = 0
    //Other locals
    var layoutType: Int = -1 //0. Static 1. Weight only 2. Dosage & Weight
    
    //Declare all outlets here
    //Input outlets
    @IBOutlet weak var weightInputTextField: UITextField!
    @IBOutlet weak var dosageInputTextField: UITextField!
    @IBOutlet weak var weightInputView: UIView!
    @IBOutlet weak var dosageInputView: UIView!
    
    //Header outlets
    @IBOutlet weak var drugNameHeaderLabel: UILabel!
    @IBOutlet weak var drugPercentHeaderLabel: UILabel!
    @IBOutlet weak var drugHeaderImageView: UIImageView!
    //Results outlets
    @IBOutlet weak var resultsView: UIView!
    @IBOutlet weak var resultsLabel: UILabel!
    
    
    //Declare all actions here
    @IBAction func dosageEditChanged(_ sender: Any) {
        let dosageText = dosageInputTextField.text ?? ""
        if dosageText == "" || dosageText.count == 0{
            return
        }
        patientWeight = Float(dosageText)!
        let _ = CalculateDosage()
    }
    
    @IBAction func weightEditChanged(_ sender: Any) {
        let weightText = weightInputTextField.text ?? ""
        if weightText == "" || weightText.count == 0{
            return
        }
        patientWeight = Float(weightText)!
        let _ = CalculateDosage()
    }
    @IBAction func weightInputChanged(_ sender: Any) {
        let weightText = weightInputTextField.text ?? ""
        if weightText == "" || weightText.count == 0{
            return
        }
        patientWeight = Float(weightText)!
        let _ = CalculateDosage()
    }
    @IBAction func dosageInputChanged(_ sender: Any) {
        let dosageText = weightInputTextField.text ?? ""
        if dosageText == "" || dosageText.count == 0{
            return
        }
        patientWeight = Float(dosageText)!
        let _ = CalculateDosage()
    }
    
    //Declare all overrides here
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set the header
        drugNameHeaderLabel.text = drugName
        drugPercentHeaderLabel.text = drugDetails?["specs"] as? String
        drugHeaderImageView.image = UIImage(named: drugDetails!["display_image"] as! String)
        
        //Make the calculator keyboard show up
        weightInputTextField.becomeFirstResponder()
        
        //Decide the kind of layout based on the JSON data around the drug
        layoutType = setLayoutTypeFromJSON()
    }
    
    //Declare all custom methods here
    //Function to calculate dosage
    func CalculateDosage() -> Float {
        var dentalDosage: Float = 0
        var resultsString : String = ""
        
        if layoutType == 0 { //Static recommended dosage
            if drugDetails!["mrd_metric"] != nil {
                dentalDosage = drugDetails!["mrd_metric"] as! Float
                resultsString = "" + String(dentalDosage) + ""
            }
            else if drugDetails!["mrd_metric_min"] != nil && drugDetails!["mrd_metric_max"] != nil {
                let dentalDosageMin = drugDetails!["mrd_metric_min"] as! Float
                let dentalDosageMax = drugDetails!["mrd_metric_max"] as! Float
                resultsString = "" + String(dentalDosageMin) + " - " + String(dentalDosageMax)
            }
        }
        else if layoutType == 1{ //Weight only recommended dosage
            let mrd_metric = drugDetails!["mrd_metric"] as! Float
            dentalDosage = ((patientWeight / 0.453592) * Float(mrd_metric) ) / 1000
            resultsString = "" + String(dentalDosage) + ""
        }
        else { //Weight and Dosage recommended dosage
            
        }
        resultsLabel.text = resultsString
        return dentalDosage
    }
    
    //Function to set the layout based on drug type's dosage and unit dose
    func setLayoutTypeFromJSON () -> Int {
        //Three types of layout:
        //1. Static: has json data called "static" in unit_dosage feild
        let unit_dosage = drugDetails!["unit_dosage"] as! String
        if unit_dosage == "static"{
            //Hide both weight and dosage - just show results
            weightInputView.isHidden = true
            dosageInputView.isHidden = true
            return 0
        }
        else{ //Determine which type of weight layout
            //2. Weight & Dosage layout - JSON does have key called "mrd_metric_max"
            let keyExists = drugDetails!["mrd_metric_max"] != nil
            if keyExists == true {
                //Show both - don't hide anything
                return 2
            }
            else {
                //3. Weight only layout - hide dosage
                dosageInputView.isHidden = true
                return 1
            }
        }
    }
    
}

/*
 //just weight needed
 {
 "dentist_types": ["general", "omfs", "pedo", "perio", "prostho", "endo", "oral_path"],
 "name": "Clindamycin",
 "display": true,
 "specs": "For Endocarditis prophylaxis (age 12 years and under)",
 "method": "pill",
 "unit_dosage": "weight",
 "mrd_metric": 20,
 "max_dosage": 600,
 "note": "Used for odontogenic infections. Use if penicillin allergy; 1 hr before appointment; may cause GI disturbance",
 "display_image": "dashboard_antibiotic"
 },
 //dosage needed
 {
 "dentist_types": ["general", "omfs", "pedo", "perio", "prostho", "endo", "oral_path"],
 "name": "Penicillin - Children",
 "display": true,
 "specs": "For age 12 years and under",
 "brand": "Penicillin VK™",
 "method": "pill",
 "unit_dosage": "weight",
 "mrd_metric_min": 25,
 "mrd_metric_max": 50,
 "max_dosage": 3000,
 "note": "Used for odontogenic infections. In equally divided doses q6-8h for at least 7 days; maximum dose: 3.0g/day",
 "display_image": "dashboard_antibiotic"
 },
 //STATIC
 {
 "dentist_types": ["general", "omfs", "pedo", "perio", "prostho", "endo", "oral_path"],
 "name": "Penicillin - Adult",
 "display": true,
 "specs": "For age over 12 years",
 "brand": "Penicillin VK™",
 "method": "pill",
 "unit_dosage": "static",
 "mrd_metric": 500,
 "max_dosage": 500,
 "note": "Used for odontogenic infections. q6h for at least 7 days",
 "display_image": "dashboard_antibiotic"
 },
 */
