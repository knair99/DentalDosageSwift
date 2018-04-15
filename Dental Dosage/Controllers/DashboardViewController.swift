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
    let row_height = 60
    var settings : Settings?
    //All drug data
    var drugModel : DrugModel?
    
    var dashboardDummyArray : [[String]]?
    var currentIndex : Int = 0
    
    //Declare all outlets here
    @IBOutlet weak var dashboardTableView: UITableView!
    @IBOutlet weak var dashTabSegments: UISegmentedControl!
    
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
        
        //Get JSON Data from App delegate where it was intialized
        let delegate = UIApplication.shared.delegate as! AppDelegate
        drugModel = delegate.drugModel!
        
        //Get drug model info out of JSON
        dashboardDummyArray = [
            (drugModel?.drugCategoriesNames)!, //All drug types
            (drugModel?.drugRecentNames)!, //Recents
            (drugModel?.drugFavoriteNames)! //Favorites
            ]
    }
}

//Extend the dashboard viewcontroller to handle table views
extension DashboardViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dashboardDummyArray![currentIndex].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.item
        let dashboardValues = dashboardDummyArray![currentIndex][index]
        let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardTableViewCell") as! DashboardTableViewCell
        cell.setCell(drugLabel: dashboardValues, drugImage: "dashboard_anasthetic")
        return cell
    }
    //Make sure that the row selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Segue into specific view controller
        
    }
    
    //Adding method to make sure the row height is proper
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(row_height);//Choose your custom row height
    }
    
}

