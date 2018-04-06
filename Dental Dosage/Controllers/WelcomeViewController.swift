//
//  WelcomeViewController.swift
//  Dental Dosage
//
//  Created by Karunakaran Prasad on 3/31/18.
//  Copyright © 2018 BayMonkeys. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func welcomeButtonNextPressed(_ sender: Any) {
        let parent = self.parent as! OnboardingViewController
        parent.moveNextController(currentViewController: self)
    }


}
