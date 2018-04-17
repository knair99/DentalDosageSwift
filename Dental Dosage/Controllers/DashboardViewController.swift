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
    
    override func viewDidAppear(_ animated: Bool) {
        //Get drug model info out of JSON
        dashboardAllTabContentsArray = [
            (drugModel?.drugCategoriesNames)!, //All drug types
            (drugModel?.drugRecentNames)!, //Recents
            (drugModel?.drugFavoriteNames)! //Favorites
        ]
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
        else { //TODO: Prepare data for transition to Dosage View (Favorites and Recents)
            
            
        }
    }
}

//Extend the dashboard viewcontroller to handle table views
extension DashboardViewController: UITableViewDataSource, UITableViewDelegate, DrugTypeCellDelegate {
    //Save favorites data into global settings
    func updateFavorites(drugName: String, remove: Bool) {
        let defaults = UserDefaults.standard
        var favorites = defaults.array(forKey: "favoriteMedicines") as? [String] ?? []
        if remove == false {
            //Add to favorites if not already in there
            if !favorites.contains(drugName) {
                favorites.append(drugName)
            }
        }
        else {
            //Remove from favorites
            favorites = favorites.filter {$0 != drugName}
        }
        //Update the drugModel JSON so the favorites tab will reflect this
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let drugModel = delegate.drugModel!
        drugModel.drugFavoriteNames = favorites
        
        //Save settings to user defaults
        defaults.set(favorites, forKey: "favoriteMedicines")
        defaults.synchronize()
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
        else{ //Recents, and favorites are drug type cells
            //Get the right drug
            let index = indexPath.item
            let drugName = drugModel?.drugFavoriteNames[index]
            let drug = drugModel?.drugDetailsDictionary[drugName!] as! [String:Any]
            
            //Get name; If too long, clip it to 10 chars
            var name = drug["name"] as! String
            if name.count > 15 {
                let startIndex = name.index(name.startIndex, offsetBy: 10)
                name = String(name[..<startIndex])
            }
            //Get brand, if no brand exists, just use the name of the drug
            var brand =  drug["brand"] as? String
            if brand == nil || brand?.count == 0{
                brand = name
            }
            //Get percent - if no spec exists, just mention method name
            var percent = drug["specs"] as? String
            if percent ==  nil || percent!.count >= 25 {
                percent = drug["method"] as? String
            }
            
            //Update cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "drugFavViewCell") as! DrugTypeTableViewCell
            cell.setCell(name: name, percent: percent!, brand: brand!)
            cell.setSegue(segueToUse: "favRecentToDosageSeugue")
            
            //Remember to set the cell delegate for the transition protocol
            cell.drugListCellDelegate = self
            return cell
        }
        
    }
    
    
    //Make sure that the row selected opens its specific viewcontroller
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Segue into specific view controller
        performSegue(withIdentifier: "dashToDrugListSegue", sender: self)

    }
    
}

