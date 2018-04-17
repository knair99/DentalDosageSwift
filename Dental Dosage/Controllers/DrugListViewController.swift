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
}

extension DrugListViewController: UITableViewDelegate, UITableViewDataSource, DrugTypeCellDelegate {
    
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
        var name = drug["name"] as! String
        if name.count > 15 {
            let startIndex = name.index(name.startIndex, offsetBy: 10)
            name = String(name[..<startIndex])
        }
        
        //Get brand, if no brand exists, just use the name of the drug
        var brand =  drug["brand"] as? String
        if brand == nil || brand?.count == 0{
            brand = ""
        }
        
        //Get percent - if no spec exists, just mention method name
        var percent = drug["specs"] as? String
        if percent ==  nil || percent!.count >= 25 {
            percent = drug["method"] as? String
        }
        
        //U[date cell
        let cell = drugListTableView.dequeueReusableCell(withIdentifier: "drugTableViewCell") as! DrugTypeTableViewCell
        cell.setCell(name: name, percent: percent!, brand: brand!)
        cell.setSegue(segueToUse: "drugListToDosageSegue")
        
        //Remember to set the cell delegate for the transition protocol
        cell.drugListCellDelegate = self
        return cell
    }
    
    
    
}

