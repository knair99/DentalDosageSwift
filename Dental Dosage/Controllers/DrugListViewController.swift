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
    var drugModel: DrugModel?
    var drugArray : [Any]?
    
    //Declare all outlets here
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Load drug info from the JSON data
        let categories = drugModel?.drugDictionaryByCategory
        for category in categories! {
            let drugCategoryName = category["name"] as! String
            if drugCategoryName == drugTypeName {
                drugArray = (category["drugs"] as! [Any])
                break;
            }
        }
    }

}
