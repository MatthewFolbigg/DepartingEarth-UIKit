//
//  LaunchDetailViewController.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 05/04/2021.
//

import Foundation
import UIKit

class LaunchDetailViewController: UIViewController {
    
    @IBOutlet var testLabel: UILabel!
    
    var launch: Launch?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let launch = launch else {
            print("Error")
            return
        }
        testLabel.text = launch.name
    }
    
}
