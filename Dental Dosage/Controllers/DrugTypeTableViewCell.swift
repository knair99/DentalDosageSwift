//
//  DrugTypeTableViewCell.swift
//  Dental Dosage
//
//  Created by Karunakaran Prasad on 4/16/18.
//  Copyright © 2018 BayMonkeys. All rights reserved.
//

import UIKit

class DrugTypeTableViewCell: UITableViewCell {

    //Declare all locals here
    let fixedTrailingSpace : String = "  "
    
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
    @objc func favoritesViewTapped(_ sender: UITapGestureRecognizer) {
        print ("Fav tapped")
    }
    @objc func drugDetailsViewTapped(_ sender: UITapGestureRecognizer){
        print ("Details tapped")
    }
    
  
}
