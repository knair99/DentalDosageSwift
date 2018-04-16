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
    
    //Details of next view controller
    var drugListViewController: DrugListViewController?
    
    //All drug data
    var drugModel : DrugModel?
    var dashboardDrugNames : [[String]]?
    var dashboardDrugImages: [String]?
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
        
        //Get info about next View controller
        drugListViewController = DrugListViewController()
        
        //Get JSON Data from App delegate where it was intialized
        let delegate = UIApplication.shared.delegate as! AppDelegate
        drugModel = delegate.drugModel!
        
        //Get drug model info out of JSON
        dashboardDrugNames = [
            (drugModel?.drugCategoriesNames)!, //All drug types
            (drugModel?.drugRecentNames)!, //Recents
            (drugModel?.drugFavoriteNames)! //Favorites
            ]
        //Get drug image names too
        dashboardDrugImages = drugModel?.drugCategoriesImages
    }
    
    //Handle segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Prep data to be passed into "Drug List" view controller
        drugListViewController = segue.destination as? DrugListViewController
        let index = dashboardTableView.indexPathForSelectedRow!.row
        
        //Set the header
        let dashboardDrugName = dashboardDrugNames![currentIndex][index]
        drugListViewController?.drugListHeader = dashboardDrugName
        
        //Prepare the entire names of drug lists
        
    }
}

//Extend the dashboard viewcontroller to handle table views
extension DashboardViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dashboardDrugNames![currentIndex].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Get approp table index
        let index = indexPath.item
        
        //Get approp drug data
        let dashboardDrugName = dashboardDrugNames![currentIndex][index]
        let dashboardImageName = dashboardDrugImages![index]
        
        //Get cell to update, update, and return it for rendering
        let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardTableViewCell") as! DashboardTableViewCell
        cell.setCell(drugLabel: dashboardDrugName, drugImage: dashboardImageName)
        return cell
    }
    
    
    //Make sure that the row selected opens its specific viewcontroller
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Segue into specific view controller
        performSegue(withIdentifier: "dashToDrugListSegue", sender: self)

    }
    
    //Adding method to make sure the row height is proper
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(row_height);//Choose your custom row height
    }
    
}

