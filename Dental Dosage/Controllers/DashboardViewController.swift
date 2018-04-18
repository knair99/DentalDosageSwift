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
    //Every time view reloads, or initialized
    func updateDashTableDataArray(){
        dashboardAllTabContentsArray = [
            (drugModel?.drugCategoriesNames)!, //All drug types, currentIndex = 0
            (drugModel?.drugRecentNames)!, //Recents, currentIndex = 1
            (drugModel?.drugFavoriteNames)! //Favorites, currentIndex = 2
        ]
    }
    
    //Declare all overrrides here
    //All initialization for the dashboard done here - one time inits
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
        updateDashTableDataArray()
    }
    
    //Every time the view loads (e.g, via the back button)
    override func viewDidAppear(_ animated: Bool) {
        //Get drug model info out of JSON
        updateDashTableDataArray()
    }
    
    //Handle segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if currentIndex == 0 { //Prepare for drug list transition
            //Prep data to be passed into "Drug List" view controller
            drugListViewController = segue.destination as? DrugListViewController
            let index = dashboardTableView.indexPathForSelectedRow!.row
            
            //Set the header
            let dashboardDrugName = dashboardAllTabContentsArray![currentIndex][index]
            drugListViewController?.drugTypeName = dashboardDrugName
            
            //Give new view its appropriate list of specific drugs
            let drugTypeDetails  = drugTypeDictionary![dashboardDrugName] as! [String:Any]
            let dashboardImageName = drugTypeDetails["display_image"] as! String
            drugListViewController?.drugTypeImage = dashboardImageName
            drugListViewController?.drugArray = (drugTypeDetails["drugs"] as! [[String:Any]])
        }
        else {
            //TODO: Prepare data for transition to Dosage View (Favorites and Recents)
        }
    }
}

//Extend the dashboard viewcontroller to handle table views, and cell delagates for favorites and recent
extension DashboardViewController: UITableViewDataSource, UITableViewDelegate, FavOrRecentTableViewCellDelegate {
    
    //Ask tableView to reload
    func askTableViewToReload(){
        dashboardTableView.reloadData()
    }
    
    //Save favorites/recents data into global settings
    func updateFavoritesOrRecents(drugName: String, remove: Bool, favorites: Bool) {
        let defaults = UserDefaults.standard
        var arrayOfSavedMeds : [String] = []
        var key : String  = ""
        if favorites == true {
            arrayOfSavedMeds = defaults.array(forKey: "favoriteMedicines") as? [String] ?? []
            key = "favoriteMedicines"
        }
        else{
            arrayOfSavedMeds = defaults.array(forKey: "recentMedicines") as? [String] ?? []
            key = "recentMedicines"
        }
        
        //Do appropriate add or remove operation
        if remove == false { //Add drug to Recents/Fav
            //If Recents, then make sure there's a circular limit of 5
            if favorites == false &&  arrayOfSavedMeds.count == 5 {
                arrayOfSavedMeds.remove(at: 0) //Remove the oldest meds
            }
            
            //Add to favorites/recents if not already in there
            if !arrayOfSavedMeds.contains(drugName) {
                arrayOfSavedMeds.append(drugName)
            }
        }
        else {
            //Remove from favorites only
            if favorites == true {
                arrayOfSavedMeds = arrayOfSavedMeds.filter {$0 != drugName}
            }
            //There is no removing from recents - Automatically removed after 5 (Circular buffer)
        }
        
        //Update the drugModel JSON so the favorites tab will reflect this
//        let delegate = UIApplication.shared.delegate as! AppDelegate
//        let drugModel = delegate.drugModel!
        if favorites == true {
            drugModel?.drugFavoriteNames = arrayOfSavedMeds
        }
        else {
            drugModel?.drugRecentNames = arrayOfSavedMeds
        }
        
        //Save settings to user defaults
        defaults.set(arrayOfSavedMeds, forKey: key)
        defaults.synchronize()
        
        //And this is key, update the appropriate dashboardAllTabContents array
        let correctIndex = favorites == true ?  2 : 1
        dashboardAllTabContentsArray![correctIndex] = arrayOfSavedMeds
    }
    
    //Perform transition to calculator
    func transitionToDosageView(data: Any?, segue: String) {
        //Segue to new dosage view controller
        performSegue(withIdentifier: segue, sender: self)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dashboardAllTabContentsArray![currentIndex].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Get approp table index
        let index = indexPath.item
        
        if currentIndex == 0 {
        //Get approp drug data - name and display image
            let dashboardDrugName = dashboardAllTabContentsArray![currentIndex][index]
            let drugType =  drugTypeDictionary![dashboardDrugName] as! [String: Any]
            let dashboardImageName = drugType["display_image"] as! String
            
            //Get cell to set name and image, update, and return for rendering
            let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardTableViewCell") as! DashboardTableViewCell
            cell.setCell(drugLabel: dashboardDrugName, drugImage: dashboardImageName)
            return cell
        }
        else{ //Recents, and favorites are drug type cells - require different treatment
            //Get the right drug
            let index = indexPath.item
            var drugName : String = ""
            
            if currentIndex == 2 { //Favorites
                drugName = (drugModel?.drugFavoriteNames[index])!
            }
            else if currentIndex == 1 { //Recents
                drugName = (drugModel?.drugRecentNames[index])!
            }
            
            //Get drug details after choosing the right drug
            let drug = drugModel?.drugDetailsDictionary[drugName] as! [String:Any]
            
            //Get name
            let name = drug["name"] as! String
            //Get brand, if no brand exists, just use the name of the drug
            let brand =  drug["brand"] as? String ?? name
            //Get percent - if no spec exists, just mention method name
            let percent = drug["specs"] as? String ?? drug["method"] as? String
            //Update cell
            let isFavorites = currentIndex == 2 ? true : false

            let cell = tableView.dequeueReusableCell(withIdentifier: "drugFavViewCell") as! FavOrRecentTableViewCell
            cell.setCell(name: name, percent: percent!, brand: brand, isFavorites: isFavorites, segueToUse: "favRecentToDosageSeugue")
            //Remember to set the cell delegate for the transition protocol
            cell.favOrRecentListCellDelegate = self
            return cell
        }
    }
    
    //Make sure that the row selected opens its specific viewcontroller
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Segue into specific view controller
        performSegue(withIdentifier: "dashToDrugListSegue", sender: self)

    }
    
}

