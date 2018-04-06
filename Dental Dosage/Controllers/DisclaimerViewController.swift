//
//  DisclaimerViewController.swift
//  Dental Dosage
//
//  Created by Karunakaran Prasad on 4/6/18.
//  Copyright © 2018 BayMonkeys. All rights reserved.
//

import UIKit

class DisclaimerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
   
    @IBAction func disclaimerAcceptPressed(_ sender: Any) {
        let parent = self.parent as! OnboardingViewController
        parent.moveNextController(currentViewController: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
