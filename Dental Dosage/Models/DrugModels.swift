//
//  DrugModel.swift
//  Dental Dosage
//
//  Created by Karunakaran Prasad on 4/13/18.
//  Copyright © 2018 BayMonkeys. All rights reserved.
//

import Foundation


class DrugModel {
    
    //Entire JSON dump
    var jsonData : [String: Any]?
    //Root of all dental JSON data
    var drugCategoriesNames: [String] = []
    //All drug information
    var drugDictionaryByCategory : [[String: Any]] = []
    
    //Get the JSON out in the initializer
    init(resource jsonResource: String) {
        if let path = Bundle.main.path(forResource: jsonResource, ofType: "json") {
            do {
                //First, procure the file out of the resources
                let fileData = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                
                //Next get the json from the data read from file
                jsonData = try! JSONSerialization.jsonObject(with: fileData, options: []) as! [String : Any]
             
                if let jsonCategories = jsonData!["categories"] as? [[String: Any]] {
                    //Save dictionary of category vs drug info as a dictionary
                    drugDictionaryByCategory =  jsonCategories
                    
                    //Extract all drug categories into a separate array
                    for category in jsonCategories {
                        drugCategoriesNames.append(category["name"] as! String)
                        print("\(String(describing: category["name"]))")
                    }
                }
            }
            catch {
                //TODO: Define logical exception and recovery route
            }
        }
    }
    
}
