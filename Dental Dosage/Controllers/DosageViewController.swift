//
//  DosageViewController.swift
//  Dental Dosage
//
//  Created by Karunakaran Prasad on 4/18/18.
//  Copyright © 2018 BayMonkeys. All rights reserved.
//

import UIKit

class DosageViewController: UIViewController {
    @IBOutlet weak var resultsField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        resultsField.becomeFirstResponder()
    }


}
