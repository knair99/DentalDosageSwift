//
//  OnboardingViewController.swift
//  Dental Dosage
//
//  Created by Karunakaran Prasad on 3/31/18.
//  Copyright © 2018 BayMonkeys. All rights reserved.
//

import UIKit

class OnboardingViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var vcArray : [UIViewController] = []
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let index = vcArray.index(of: viewController) ?? 0
        let prevIndex = index - 1
        guard prevIndex >= 0 else { return nil}
        guard vcArray.count > prevIndex else {return nil}
        return vcArray[prevIndex]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let index = vcArray.index(of: viewController) ?? 0
        let nextIndex = index + 1
        guard nextIndex < vcArray.count else { return nil}
        return vcArray[nextIndex]
    }
    
    //Function for NEXT buttons to manually move to the next ViewController
    public func moveNextController(currentViewController: UIViewController){
        let index = vcArray.index(of: currentViewController) ?? 0
        let next = index + 1 //Get the next view controller's index
        guard vcArray.count != next else {return}
        guard vcArray.count > next else {return}
        let nextViewController = vcArray[next]
        self.setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let welcomeVc = sb.instantiateViewController(withIdentifier: "Welcome") as! WelcomeViewController
        let dentistTypeVc = sb.instantiateViewController(withIdentifier: "DentistType") as! DentistTypeViewController
        let metricVc = sb.instantiateViewController(withIdentifier: "Metric") as! MetricViewController
    
        vcArray = [welcomeVc, dentistTypeVc, metricVc]
        
        if let firstViewController = vcArray.first {
        setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }


}
