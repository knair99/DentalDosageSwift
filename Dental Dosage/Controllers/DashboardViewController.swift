//
//  DashboardViewController.swift
//  Dental Dosage
//
//  Created by Karunakaran Prasad on 3/31/18.
//  Copyright © 2018 BayMonkeys. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {
    //Declare all locals here
    
    //Declare all outlets here
    
    //Declare all actions here
    
    //Declare all custom methods here
    //Retrieve user settings
    func GetInitialUserSettings(){
        let defaults = UserDefaults.standard
        if let savedSettings = defaults.object(forKey: "DefaultSettingsKey") as? Data {
            let settings = NSKeyedUnarchiver.unarchiveObject(with: savedSettings) as! Settings
            print("\(settings)")
        }
    }
    
    //Declare all overrrides here
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get initial user settings
        GetInitialUserSettings()
    }
    

}

