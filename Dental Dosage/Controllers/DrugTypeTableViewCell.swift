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
    
    //Declare all custom methods here
    func setCell(name:String, percent:String, brand:String){
        
        drugNameLabel.text = name
        drugBrandLabel.text = brand + fixedTrailingSpace
        drugPercentLabel.text = percent
    }
    
    //Declare all overrides here
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
