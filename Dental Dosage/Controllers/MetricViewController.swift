//
//  MetricViewController.swift
//  Dental Dosage
//
//  Created by Karunakaran Prasad on 3/31/18.
//  Copyright © 2018 BayMonkeys. All rights reserved.
//

import UIKit

class MetricViewController: UIViewController {

    //Declare locals here
    var metricTypesArray : [Metric] = []
    
    //Declare outlets here
    @IBOutlet weak var metricTableView: UITableView!
    
    //Declare all actions here
    //Method to move the screen from current controller to next upon button press
    @IBAction func metricButtonNextPressed(_ sender: Any) {
        let parent = self.parent as! OnboardingViewController
        parent.performTransitionToDashboard()
    }
    
    //Create all custom methods here
    func CreateMetricTypes () {
        metricTypesArray.append(Metric(metricType: "Metric (Or decimal system)", isSelected: false, key: "metric"))
        metricTypesArray.append(Metric(metricType: "The US Standard", isSelected: false, key: "us"))
    }
    
    //Declare all overrides here
    override func viewDidLoad() {
        super.viewDidLoad()
        CreateMetricTypes()
        metricTableView.delegate = self
        metricTableView.dataSource = self
    }
}

//Need to set cell delegates for the view controller to implement (take action on)
extension MetricViewController : OBMetricCellDelegate {
    func didTapMetricSwitch(metricChosen: String) {
        let parent = self.parent as! OnboardingViewController
        parent.userSettings.setMetric(metricChosen: metricChosen)
    }
    
    func updateSwitchState(indexPath: IndexPath, isSelected: Bool) {
        let metric = metricTypesArray[indexPath.item]
        metric.isSelected = isSelected
    }
}

//Need to extend this class to accomodate a table view and its delegates
extension MetricViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return metricTypesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let metric = metricTypesArray[indexPath.item]
        let cell = metricTableView.dequeueReusableCell(withIdentifier: "MetricPrototypeCell") as! OBMetricTableViewCell
        cell.setCell(metricLabel: metric.metricType, isSelected: metric.isSelected)
        //Set the cell delegate for the appropriate action on items in the cell
        cell.delegate = self
        return cell
    }
    
    
}
