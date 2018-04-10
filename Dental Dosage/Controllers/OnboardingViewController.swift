//
//  OnboardingViewController.swift
//  Dental Dosage
//
//  Created by Karunakaran Prasad on 3/31/18.
//  Copyright © 2018 BayMonkeys. All rights reserved.
//

import UIKit

class OnboardingViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    //Declare all locals here
    var vcArray : [UIViewController] = []
    
    //Declare onboarding user settings object to be saved at each transition (or button click)
    var userSettings : Settings = Settings(dentistTypesChosen: [], metricChosen: "")
    
    //Declare all custom methods here
    
    //Function for NEXT buttons to manually move to the next ViewController - called from individual view controller
    public func moveNextController(currentViewController: UIViewController){
        
        //First save whatever user settings gathered
        SaveUserSettings()
        
        //Transition forward
        let index = vcArray.index(of: currentViewController) ?? 0
        let next = index + 1 //Get the next view controller's index
        guard vcArray.count != next else {return}
        guard vcArray.count > next else {return}
        let nextViewController = vcArray[next]
        self.setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
    }
    
    //Declare all overrides here
    
    //Handles swiping left
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        //First save whatever user settings gathereds
        SaveUserSettings()
        
        //Transition backward
        let index = vcArray.index(of: viewController) ?? 0
        let prevIndex = index - 1
        guard prevIndex >= 0 else { return nil}
        guard vcArray.count > prevIndex else {return nil}
        return vcArray[prevIndex]
    }
    
    //Handle swiping right
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        //First save whatever user settings gathered
        SaveUserSettings()
        
        //Transition forward
        let index = vcArray.index(of: viewController) ?? 0
        let nextIndex = index + 1
        guard nextIndex < vcArray.count else { return nil}
        return vcArray[nextIndex]
    }
    //All custom actions after view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set the page view controller to be the data source and delegate for all its view controller contents
        self.dataSource = self
        self.delegate = self
        
        //Set up all views in an array - Get through storyboard id
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let disclaimerVc = sb.instantiateViewController(withIdentifier: "Disclaimer")as! DisclaimerViewController
        let welcomeVc = sb.instantiateViewController(withIdentifier: "Welcome") as! WelcomeViewController
        let dentistTypeVc = sb.instantiateViewController(withIdentifier: "DentistType") as! DentistTypeViewController
        let metricVc = sb.instantiateViewController(withIdentifier: "Metric") as! MetricViewController
        
        //Store in local array so the approp viewcontroller can be retrieved via index later (while swiping or NEXT button press)
        vcArray = [disclaimerVc, welcomeVc, dentistTypeVc, metricVc]
        if let firstViewController = vcArray.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    //Save all user settings when required (each transition)
    func SaveUserSettings(){
        
        //Save settings collected first into default settings
        let defaults = UserDefaults.standard
        let userSettingsEncoded = NSKeyedArchiver.archivedData(withRootObject: userSettings)
        defaults.set(userSettingsEncoded, forKey: "DefaultSettingsKey")
        defaults.synchronize()
    }
    
}
