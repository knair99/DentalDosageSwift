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
    
    init(dentistType: String, isSelected: Bool) {
        self.dentistType = dentistType
        self.isSelected = isSelected
    }
}
