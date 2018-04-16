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
    
    //The array that holds the strings current in all tabs
    //3 indexes : Drug type names = 0, Recents = 1, Favorites = 2
    //Index for currently clicked tab will be pointed to by currentIndex
    var dashboardAllTabContentsArray : [[String]]?
    var drugTypeDictionary : [String:Any]?
    
    //Denotes what tab index we're currently at
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
    //All initialization for the dashboard done here
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
        drugTypeDictionary = drugModel?.drugTypeDictionary
        
        //Get drug model info out of JSON
        dashboardAllTabContentsArray = [
            (drugModel?.drugCategoriesNames)!, //All drug types
            (drugModel?.drugRecentNames)!, //Recents
            (drugModel?.drugFavoriteNames)! //Favorites
            ]
    }
    
    //Handle segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Prep data to be passed into "Drug List" view controller
        drugListViewController = segue.destination as? DrugListViewController
        let index = dashboardTableView.indexPathForSelectedRow!.row
        
        //Set the header
        let dashboardDrugName = dashboardAllTabContentsArray![currentIndex][index]
        drugListViewController?.drugTypeName = dashboardDrugName
        
        //Give new view its appropriate list of specific drugs
        let drugTypeDetails  = drugTypeDictionary![dashboardDrugName] as! [String:Any]
        drugListViewController?.drugArray = (drugTypeDetails["drugs"] as! [[String:Any]])
    }
}

//Extend the dashboard viewcontroller to handle table views
extension DashboardViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dashboardAllTabContentsArray![currentIndex].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Get approp table index
        let index = indexPath.item
        
        //Get approp drug data - name and display image
        let dashboardDrugName = dashboardAllTabContentsArray![currentIndex][index]
        let drugType =  drugTypeDictionary![dashboardDrugName] as! [String: Any]
        let dashboardImageName = drugType["display_image"] as! String
        
        //Get cell to set name and image, update, and return for rendering
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

