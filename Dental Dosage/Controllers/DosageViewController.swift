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
    var drugName: String?
    var drugDetails : [String:Any]?
    
    //Declare all outlets here
    @IBOutlet weak var weightInputTextField: UITextField!
    @IBOutlet weak var drugNameHeaderLabel: UILabel!
    @IBOutlet weak var drugPercentHeaderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set the header
        drugNameHeaderLabel.text = drugName
        drugPercentHeaderLabel.text = drugDetails?["specs"] as? String
        
        //Make the calculator keyboard show up
        weightInputTextField.becomeFirstResponder()
    }

}
