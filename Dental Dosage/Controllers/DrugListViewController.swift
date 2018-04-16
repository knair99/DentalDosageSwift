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
    
    //Declare all overrides here
    override func viewDidLoad() {
        super.viewDidLoad()
        drugNameHeader.text = drugTypeName
        drugHeaderImage.image = UIImage(named:drugTypeImage)
        
        //Get individual drug names into specific types array for cell view later
        for drug in drugArray {
            let name = drug["name"] as! String
            drugNamesArray.append(name)
        }
    }
}

extension DrugListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drugArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.item
        let drug = drugArray[index]
        let name = drug["name"] as! String
        var percent = drug["specs"] as? String
        var brand =  drug["brand"] as? String
        if brand == nil {
            brand = name
        }
        if percent ==  nil || percent!.count >= 25 {
            percent = drug["method"] as? String
        }
        let cell = drugListTableView.dequeueReusableCell(withIdentifier: "drugTableViewCell") as! DrugTypeTableViewCell
        cell.setCell(name: name, percent: percent!, brand: brand!)
        return cell
    }
    
    
    
}

