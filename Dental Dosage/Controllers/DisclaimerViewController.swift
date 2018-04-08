//
//  DisclaimerViewController.swift
//  Dental Dosage
//
//  Created by Karunakaran Prasad on 4/6/18.
//  Copyright © 2018 BayMonkeys. All rights reserved.
//

import UIKit

class DisclaimerViewController: UIViewController {

   //Declare all actions here
    @IBAction func disclaimerAcceptPressed(_ sender: Any) {
        let parent = self.parent as! OnboardingViewController
        parent.moveNextController(currentViewController: self)
    }
    
    //Declare all overrides here
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
