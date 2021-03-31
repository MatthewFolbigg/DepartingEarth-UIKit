//
//  TestViewController.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 30/03/2021.
//

import Foundation
import UIKit

class TestViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LaunchLibraryApiClient.getLaunches { (launches, error) in
            guard let launches = launches else {
                return
            }
            
            for launchInfo in launches {
                print(launchInfo.name)
            }
        }

    }
}
