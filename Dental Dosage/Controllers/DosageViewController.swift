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
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var drugNameHeaderLabel: UILabel!
    @IBOutlet weak var drugPercentHeaderLabel: UILabel!
    @IBOutlet weak var drugHeaderImageView: UIImageView!
    @IBOutlet weak var dosageInfoLabel: UILabel!
    //Results outlets
    @IBOutlet weak var resultsView: UIView!
    @IBOutlet weak var resultsLabel: UILabel!
    //Constraints outlets
    @IBOutlet weak var resultViewTopConstraint: NSLayoutConstraint!
    
    //Declare all actions here
    @IBAction func dosageEditChanged(_ sender: Any) {
        let dosageText = dosageInputTextField.text ?? ""
        if dosageText == "" || dosageText.count == 0{
            return
        }
        dosageAmount = Float(dosageText)!
        let _ = calculateDosageAndUpdateResults()
    }
    
    @IBAction func weightEditChanged(_ sender: Any) {
        let weightText = weightInputTextField.text ?? ""
        if weightText == "" || weightText.count == 0{
            return
        }
        patientWeight = Float(weightText)!
        let _ = calculateDosageAndUpdateResults()
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
        //Immediately display recommended dosage if static recommendation
        if layoutType == 0 {
            let _ = calculateDosageAndUpdateResults()
        }
        else if layoutType == 2 {
        //If both weight and dosage info is required, then update min/max info in the label
            dosageInfoLabel.text = "Dosage (Between " + String(drugDetails!["mrd_metric_min"] as! Float) + " - " + String(drugDetails!["mrd_metric_max"] as! Float)  + ")"
        }
    }
    
    //Declare all custom methods here
    //Function to calculate dosage
    func calculateDosageAndUpdateResults() -> Float {
        var dentalDosage: Float = 0
        var dentalDosageMaximumLimit : Float = drugDetails!["max_dosage"] as! Float
        
        var resultsString : String = ""
        
        if layoutType == 0 { //Static recommended dosage
            if drugDetails!["mrd_metric"] != nil {
                dentalDosage = drugDetails!["mrd_metric"] as! Float
                resultsString = "" + String(dentalDosage) + ""
            }
            else if drugDetails!["mrd_metric_min"] != nil && drugDetails!["mrd_metric_max"] != nil {
                let dentalDosageMin = drugDetails!["mrd_metric_min"] as! Float
                let dentalDosageMax = drugDetails!["mrd_metric_max"] as! Float
                dentalDosage = dentalDosageMax
                resultsString = "" + String(dentalDosageMin) + " - " + String(dentalDosageMax)
            }
        }
        else if layoutType == 1{ //Weight only recommended dosage
            let mrd_metric = drugDetails!["mrd_metric"] as! Float
            dentalDosage = ((patientWeight / 0.453592) * Float(mrd_metric) ) / 1000
            resultsString = "" + String(dentalDosage) + ""
        }
        else { //Weight and Dosage recommended dosage
            //TODO - Check with Anu
            if drugDetails!["mrd_metric_min"] != nil && drugDetails!["mrd_metric_max"] != nil {
                let dentalDosageMin = drugDetails!["mrd_metric_min"] as! Float
                let dentalDosageMax = drugDetails!["mrd_metric_max"] as! Float
                
                //Take care of edge cases here:
                if dosageAmount >= dentalDosageMin && dosageAmount <= dentalDosageMax {
                    dentalDosage = ((patientWeight / 0.453592) * dosageAmount ) / 1000
                    resultsString = "" + String(dentalDosage) + ""
                }
                else if dosageAmount > dentalDosageMax {
                    let alertController = UIAlertController(title: "Dosage limit", message: "Dosage should be between \(dentalDosageMin) and \(dentalDosageMax)", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        //Check to see that the calculations hasn't gotten past max dosage
        if dentalDosage >= dentalDosageMaximumLimit{
            resultsString = String(dentalDosageMaximumLimit)
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
            //Pull results view up to below the headerview's y position
            resultViewTopConstraint.constant = resultViewTopConstraint.constant - weightInputView.frame.height - dosageInputView.frame.height
            resultsView.layoutIfNeeded()
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
                //Pull results view up to below the headerview's y position
                resultViewTopConstraint.constant = resultViewTopConstraint.constant - dosageInputView.frame.height
                return 1
            }
        }
    }
    
}


