//
//  DrugTypeTableViewCell.swift
//  Dental Dosage
//
//  Created by Karunakaran Prasad on 4/16/18.
//  Copyright © 2018 BayMonkeys. All rights reserved.
//

import UIKit

//Create a protocol here to perform segue & save data
protocol DrugTypeCellDelegate {
    //Pass data through here later on, if need be
    func transitionToDosageView (data: Any?)
    func updateFavorites (drugName: String, remove: Bool)
}

class DrugTypeTableViewCell: UITableViewCell {

    //Declare all locals here
    let fixedTrailingSpace : String = "  "
    var favoritesSwitched = false
    
    var drugListCellDelegate: DrugTypeCellDelegate!
    
    //Declare all outlets here
    @IBOutlet weak var drugNameLabel: UILabel!
    @IBOutlet weak var drugPercentLabel: UILabel!
    @IBOutlet weak var drugBrandLabel: UILabel!
    @IBOutlet weak var favoritesView: UIView!
    @IBOutlet weak var drugDetailsView: UIView!
    

    //Declare all overrides here
    override func awakeFromNib() {
        super.awakeFromNib()
        // Declare custom tap gesture recognizers
        //First for the favorites
        let favTap = UITapGestureRecognizer(target: self, action: #selector(DrugTypeTableViewCell.favoritesViewTapped(_:)))
        favTap.numberOfTapsRequired = 1
        favTap.numberOfTouchesRequired = 1
        favoritesView.addGestureRecognizer(favTap)
        
        //And then for the drug info view (rest of the cell)
        let drugDetailTap = UITapGestureRecognizer(target: self, action: #selector(DrugTypeTableViewCell.drugDetailsViewTapped(_:)))
        drugDetailTap.numberOfTapsRequired = 1
        drugDetailTap.numberOfTouchesRequired = 1
        drugDetailsView.addGestureRecognizer(drugDetailTap)
    }
    
    //Declare all custom methods here
    func setCell(name:String, percent:String, brand:String){
        
        drugNameLabel.text = name
        drugBrandLabel.text = brand + fixedTrailingSpace
        drugPercentLabel.text = percent
    }
    //Declare the tap recgnizers
    //Favorites: Change colors and store
    @objc func favoritesViewTapped(_ sender: UITapGestureRecognizer) {
        if favoritesSwitched == true { //Remove from favorites
            //Set to green
            favoritesView.backgroundColor = UIColor(red: 88/255, green: 168/255, blue: 168/255, alpha: 1)
            favoritesSwitched = false
            drugListCellDelegate.updateFavorites(drugName: drugNameLabel.text!, remove: true)
        }
        else { //Save to favorites
            //Set to pink
            favoritesView.backgroundColor = UIColor(red: 241/255, green: 141/255, blue: 154/255, alpha: 1)
            favoritesSwitched = true
            drugListCellDelegate.updateFavorites(drugName: drugNameLabel.text!, remove: false)
        }
    }
    @objc func drugDetailsViewTapped(_ sender: UITapGestureRecognizer){
        drugListCellDelegate.transitionToDosageView(data: nil)
    }
  
}
