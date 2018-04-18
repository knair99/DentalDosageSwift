//
//  FavOrRecentTableViewCell.swift
//  Dental Dosage
//
//  Created by Karunakaran Prasad on 4/18/18.
//  Copyright © 2018 BayMonkeys. All rights reserved.
//

import UIKit

//Create a protocol here to perform segue & save data
protocol FavOrRecentTableViewCellDelegate {
    //Pass data through here later on, if need be
    func transitionToDosageView (data: String, segue: String)
    func updateFavoritesOrRecents (drugName: String, remove: Bool, favorites: Bool)
    func askTableViewToReload()
}

class FavOrRecentTableViewCell: UITableViewCell {

    //Declare all locals here
    let fixedTrailingSpace : String = "  "
    var favoritesSwitched = false
    var segueToUse: String = ""
    var isFavoritesView = false
    
    var favOrRecentListCellDelegate: FavOrRecentTableViewCellDelegate!
    
    //Declare all outlets here
    @IBOutlet weak var favoritesView: UIView!
    @IBOutlet weak var drugDetailsView: UIView!
    @IBOutlet weak var drugNameLabel: UILabel!
    @IBOutlet weak var drugPercentLabel: UILabel!
    @IBOutlet weak var drugBrandLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
    func setCell(name:String, percent:String, brand:String, isFavorites:Bool, segueToUse: String){
        drugNameLabel.text = name
        drugBrandLabel.text = brand + fixedTrailingSpace
        drugPercentLabel.text = percent
        isFavoritesView = isFavorites
        self.segueToUse = segueToUse
        setColorCellFavoritesView()
    }
    
    //Color favorite's view appropriately
    func setColorCellFavoritesView(){
        if isFavoritesView == true {
            //if Favorites view, all cells should be default pink
            favoritesView.backgroundColor = UIColor(red: 241/255, green: 141/255, blue: 154/255, alpha: 1)
        }
        else{
            favoritesView.backgroundColor = UIColor(red: 88/255, green: 168/255, blue: 168/255, alpha: 1)
        }
    }
    
    //Declare the tap recgnizers
    //Favorites: Change colors and store
    @objc func favoritesViewTapped(_ sender: UITapGestureRecognizer) {
        //If this cell belongs in the recents tab, then the functionality should be
        //exactly like DrugListTableViewCell
        //I.e: The tap should put into favorites or remove appropriately
        if isFavoritesView == false { //This is Recents view
            if favoritesSwitched == true { //Remove from favorites
                //Set to green
                favoritesView.backgroundColor = UIColor(red: 88/255, green: 168/255, blue: 168/255, alpha: 1)
                favoritesSwitched = false
                favOrRecentListCellDelegate.updateFavoritesOrRecents(drugName: drugNameLabel.text!, remove: true, favorites: true)
            }
            else { //Save to favorites
                //Set to pink
                favoritesView.backgroundColor = UIColor(red: 241/255, green: 141/255, blue: 154/255, alpha: 1)
                favoritesSwitched = true
                favOrRecentListCellDelegate.updateFavoritesOrRecents(drugName: drugNameLabel.text!, remove: false, favorites: true)
            }
        }
        else { //This is Favorites view and it's tapped
            //Only option available from favorites view should be remove when tapped
            favOrRecentListCellDelegate.updateFavoritesOrRecents(drugName: drugNameLabel.text!, remove: true, favorites: true)
            //We should also ask the tableView to reload via a protocol delegate method to make it disappear
            favOrRecentListCellDelegate.askTableViewToReload()
        }
        
    }
    @objc func drugDetailsViewTapped(_ sender: UITapGestureRecognizer){
        //If user taps on a drug, save it to recents
        favOrRecentListCellDelegate.updateFavoritesOrRecents(drugName: drugNameLabel.text!, remove: false, favorites: false)
        //And then transition away into appropriate drug's dosage view
        favOrRecentListCellDelegate.transitionToDosageView(data: drugNameLabel.text!, segue: segueToUse)
    }

}
