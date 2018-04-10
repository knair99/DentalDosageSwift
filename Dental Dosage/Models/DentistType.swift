//
//  DentistType.swift
//  Dental Dosage
//
//  Created by Karunakaran Prasad on 4/6/18.
//  Copyright © 2018 BayMonkeys. All rights reserved.
//

import Foundation

//Onboarding - models needed to hold dentist type(s) chosen
class DentistType {
    
    var dentistType: String
    var isSelected: Bool
    //Need an identifier to recognize what kind of dentist later on (for key-value lookup)
    //Keys: "general", "oral", "orthodontist", "endodontist", "periodontist", "prosthodontist"
    var key : String
    
    init(dentistType: String, isSelected: Bool, key: String) {
        self.dentistType = dentistType
        self.isSelected = isSelected
        self.key =  key
    }
}
