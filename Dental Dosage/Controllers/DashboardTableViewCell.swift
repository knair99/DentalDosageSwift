//
//  DashboardTableViewCell.swift
//  Dental Dosage
//
//  Created by Karunakaran Prasad on 4/12/18.
//  Copyright © 2018 BayMonkeys. All rights reserved.
//

import UIKit

class DashboardTableViewCell: UITableViewCell {

    //Declare all outlets here
    @IBOutlet weak var drugTypeLabel: UILabel!
    @IBOutlet weak var drugTypeImageView: UIImageView!
    
    //Declare all locals here
    var fixedLeadingSpace = "   "
    
    //Declare all custom methods here
    func setCell(drugLabel: String, drugImage: String){
        drugTypeLabel.text = fixedLeadingSpace + drugLabel
        drugTypeImageView.image = UIImage(named: drugImage)
    }
    
    //Declare all overrrides here
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
