//
//  Settings.swift
//  Dental Dosage
//
//  Created by Karunakaran Prasad on 4/9/18.
//  Copyright © 2018 BayMonkeys. All rights reserved.
//

import Foundation

//Onboarding - model for saving settings data
class Settings: NSObject, NSCoding {
    
    //The two settings we are currently remembering
    //Dentist by key - defined in DentistType.swift
    var dentistTypesChosen : [String] = []
    var metricChosen : String = ""
    
    init (dentistTypesChosen: [String], metricChosen: String){
        self.dentistTypesChosen = dentistTypesChosen
        self.metricChosen = metricChosen
    }
    
    func setTypes(dentistType: String){
        dentistTypesChosen.append(dentistType)
    }
    
    func setMetric(metricChosen: String){
        self.metricChosen = metricChosen
    }
    
    //Required protocol stubs
    func encode(with aCoder: NSCoder) {
        aCoder.encode(dentistTypesChosen, forKey: "dentistTypesChosen")
        aCoder.encode(metricChosen, forKey: "metricChosen")
    }

    required init?(coder aDecoder: NSCoder) {
        dentistTypesChosen = aDecoder.decodeObject(forKey:"dentistTypesChosen") as! [String]
        metricChosen = aDecoder.decodeObject(forKey: "metricChosen") as! String
    }

    
    
}
