//
//  DrugModel.swift
//  Dental Dosage
//
//  Created by Karunakaran Prasad on 4/13/18.
//  Copyright © 2018 BayMonkeys. All rights reserved.
//

import Foundation

//Class for mining JSON input, and saving into global object during app delegate startup
class DrugModel {
    
    //Also, For recently visited and favorites
    //Names of various categories of drugs for the Dashboard screen
    var drugCategoriesNames: [String] = []
    //Drug type image names (corresponding to approp index in drugCategoriesNames)
    var drugCategoriesImages: [String] = []
    var drugRecentNames: [String] = []
    var drugFavoriteNames: [String] = []
    
    //All JSON information - root JSON array named "categories"
    var jsonRootDictionary : [[String: Any]] = []

    //Dictionary that has a drug type name as key, and all its properties as values
    var drugTypeDictionary : [String: Any] = [:]
    
    //Dictionary that has individual drugs with names as keys, and its measurements as values
    var drugDetailsDictionary : [String: Any] = [:]
    
    //Get the JSON out in the initializer
    init(resource jsonResource: String) {
        //Get favorites and recents if they exist, first, from User Defaults
        let defaults = UserDefaults.standard
        let favorites = defaults.array(forKey: "favoriteMedicines") as? [String] ?? []
        drugFavoriteNames = favorites
        let recents = defaults.array(forKey: "recentMedicines") as? [String] ?? []
        drugRecentNames = recents
        
        if let path = Bundle.main.path(forResource: jsonResource, ofType: "json") {
            do {
                //First, procure the file out of the resources
                let fileData = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                
                //Next get the json from the data read from file
                if let jsonData = try! JSONSerialization.jsonObject(with: fileData, options: []) as? [String : Any] {
                    
                    if let jsonCategories = jsonData["categories"] as? [[String: Any]] {
                        
                        //Save dictionary of category vs drug info as a dictionary
                        jsonRootDictionary =  jsonCategories
                        
                        //Extract all drug categories into a separate array
                        for category in jsonCategories {
                            let name = category["name"] as! String
                            let image = category["display_image"] as! String
                            drugCategoriesNames.append(name)
                            drugCategoriesImages.append(image)
                            
                            //Put appropriate category as key and all its elements as values
                            drugTypeDictionary[name] = category as Any
                            
                            //Put all drugs into a dictionary, indexed by drug name
                            let drugArray = category["drugs"] as! [[String:Any]]
                            for drug in drugArray {
                                let drugName = drug["name"] as! String
                                drugDetailsDictionary[drugName] = drug
                            }
                        }
                    }
                }
            }
            catch {
                //TODO: Define logical exception and recovery route
            }
        }
    }
    
}
