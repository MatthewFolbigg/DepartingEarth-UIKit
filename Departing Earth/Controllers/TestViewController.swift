//
//  TestViewController.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 30/03/2021.
//

import Foundation
import UIKit

class TestViewController: UIViewController {
    
    var dataController: DataController!
    var launches: [Launch] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LaunchLibraryApiClient.getUpcomingLaunches() { [self] (returnedLaunches, error, response)  in
            guard let returnedLaunches = returnedLaunches else {
                print("\(error?.localizedDescription ?? "")")
                print("\(response?.description ?? "")")
                return
            }
            handleGetLaunches(returnedLaunches: returnedLaunches)
        }
    }
    
    func handleGetLaunches(returnedLaunches: [LaunchInfo]) {
        for launchInfo in returnedLaunches {
            let launch = buildLauchObject(launchInfo: launchInfo)
            launches.append(launch)
        }
        printProvider()
    }
    
    func printProvider() {
        for i in launches {
            print(i.launchProvider?.name ?? "")
        }
    }
    
    func buildLauchObject(launchInfo: LaunchInfo) -> Launch {
        let launch = Launch(context: dataController.viewContext)
        let launchProvider = LaunchProvider(context: dataController.viewContext)
        let rocket = Rocket(context: dataController.viewContext)
        launch.name = launchInfo.name
        launchProvider.name = launchInfo.launchServiceProvider.name
        launchProvider.type = launchInfo.launchServiceProvider.type
        rocket.name = launchInfo.rocket.configuration.name
        rocket.family = launchInfo.rocket.configuration.family
        rocket.variant = launchInfo.rocket.configuration.variant
        launch.rocket = rocket
        launch.launchProvider = launchProvider
        return launch
    }
}
