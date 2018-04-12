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
    var settings : Settings?
    var dashboardDummyArray : [[String]] =
        [
            ["M1", "M2", "M3"], //All drug types
            ["R1", "R2", "R3"], //Recents
            ["F1", "F2", "F3"]  //Favorites
        ]
    var currentIndex : Int = 0
    
    //Declare all outlets here
    @IBOutlet weak var dashboardTableView: UITableView!
    
    //Declare all actions here
    @IBAction func dashboardTabsSwitched(_ sender: UISegmentedControl) {
        currentIndex =  sender.selectedSegmentIndex
        dashboardTableView.reloadData()
    }
    
    //Declare all custom methods here
    //Retrieve user settings
    func GetInitialUserSettings(){
        let defaults = UserDefaults.standard
        if let savedSettings = defaults.object(forKey: "DefaultSettingsKey") as? Data {
            settings = NSKeyedUnarchiver.unarchiveObject(with: savedSettings) as? Settings
        }
    }
    
    //Declare all overrrides here
    override func viewDidLoad() {
        super.viewDidLoad()
        currentIndex = 0
        //Get initial user settings
        GetInitialUserSettings()
    }
}

//Extend the dashboard viewcontroller to handle table views
extension DashboardViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dashboardDummyArray[currentIndex].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.item
        let dashboardValues = dashboardDummyArray[currentIndex][index]
        let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardTableViewCell") as! DashboardTableViewCell
        cell.setCell(drugLabel: dashboardValues, drugImage: "dashboard_anasthetic")
        return cell
    }
    //Make sure that the row selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

