//
//  Metric.swift
//  Dental Dosage
//
//  Created by Karunakaran Prasad on 4/7/18.
//  Copyright © 2018 BayMonkeys. All rights reserved.
//


import Foundation

//Onboarding - models needed to hold metric type chosen
class Metric {
    
    var metricType: String
    var isSelected: Bool
    var key: String //"metric" or "us"
    
    init(metricType: String, isSelected: Bool, key: String) {
        self.metricType = metricType
        self.isSelected = isSelected
        self.key = key
    }
}

