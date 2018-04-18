//
//  DrugListViewController.swift
//  Dental Dosage
//
//  Created by Karunakaran Prasad on 4/15/18.
//  Copyright © 2018 BayMonkeys. All rights reserved.
//

import UIKit

class DrugListViewController: UIViewController {

    //Declare all locals here
    var drugTypeName : String = "Dental Dosage"
    var drugTypeImage : String = ""
    //Contains dictionaries of each drug relevant to current drug type
    var drugArray : [[String:Any]] = []
    //Store just the names of the drugs relevant to current drug type
    var drugNamesArray : [String] = []
    
    //Declare all outlets here
    @IBOutlet weak var drugListTableView: UITableView!
    @IBOutlet weak var drugHeaderImage: UIImageView!
    @IBOutlet weak var drugNameHeader: UILabel!
    
    //Declare all custom methods here
    
    //Declare all overrides here
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set nav bar back button color
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        
        //Set header and image
        drugNameHeader.text = drugTypeName
        drugHeaderImage.image = UIImage(named:drugTypeImage)
        
        //Get individual drug names into specific types array for cell view later
        for drug in drugArray {
            let name = drug["name"] as! String
            drugNamesArray.append(name)
        }
    }
    
    //Prepare for segue to Dosage calculator view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Set the name of the back button for the individual drug clicked on, in the Dosage VC
        let backButtonItem = UIBarButtonItem()
        backButtonItem.title = drugTypeName
        navigationItem.backBarButtonItem = backButtonItem
    }
    
}

extension DrugListViewController: UITableViewDelegate, UITableViewDataSource, DrugTypeCellDelegate {
    
    //Save favorites data into global settings
    func updateFavoritesOrRecents(drugName: String, remove: Bool, favorites: Bool) {
        let defaults = UserDefaults.standard
        var arrayOfSavedMeds : [String] = []
        var key : String = ""
        if favorites == true {
            arrayOfSavedMeds = defaults.array(forKey: "favoriteMedicines") as? [String] ?? []
            key = "favoriteMedicines"
        }
        else{
            arrayOfSavedMeds = defaults.array(forKey: "recentMedicines") as? [String] ?? []
            key = "recentMedicines"
        }
        
        //Do appropriate add or remove operation
        if remove == false {
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
        
        //Update the drugModel JSON so the favorites/recents tab will reflect this
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let drugModel = delegate.drugModel!
        if favorites == true {
            drugModel.drugFavoriteNames = arrayOfSavedMeds
        }
        else {
            drugModel.drugRecentNames = arrayOfSavedMeds
        }
        
        //Save settings to user defaults
        defaults.set(arrayOfSavedMeds, forKey: key)
        defaults.synchronize()
    }
    
    //Perform transition to calculator
    func transitionToDosageView(data: Any?, segue: String) {
        //Segue to new dosage view controller
        performSegue(withIdentifier: segue, sender: self)
    }
    
    //Custom protocol stub
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drugArray.count
    }
    
    //Each time table view reloads, reload the cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Get the right drug
        let index = indexPath.item
        let drug = drugArray[index]
        
        //Get name; If too long, clip it to 10 chars
        let name = drug["name"] as! String
        
        //Get brand, if no brand exists, just use the name of the drug
        let brand =  drug["brand"] as? String ?? name
        //Get percent - if no spec exists, just mention method name
        let percent = drug["specs"] as? String ?? drug["method"]
        
        //Update cell
        let cell = drugListTableView.dequeueReusableCell(withIdentifier: "drugTableViewCell") as! DrugTypeTableViewCell
        cell.setCell(name: name, percent: percent! as! String, brand: brand)
        cell.setSegue(segueToUse: "drugListToDosageSegue")
        
        //Remember to set the cell delegate for the transition protocol
        cell.drugListCellDelegate = self
        return cell
    }
    
    
    
}

