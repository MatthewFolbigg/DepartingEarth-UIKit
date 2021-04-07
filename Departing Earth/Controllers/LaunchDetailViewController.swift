//
//  LaunchDetailViewController.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 05/04/2021.
//

import Foundation
import UIKit
import MapKit

class LaunchDetailViewController: UIViewController {
    
    @IBOutlet var rocketNameLabel: UILabel!
    @IBOutlet var agencyNameLabel: UILabel!
    @IBOutlet var locationNameLabel: UILabel!
    @IBOutlet var padNameLabel: UILabel!
    @IBOutlet var latitudeLabel: UILabel!
    @IBOutlet var longitudeLabel: UILabel!
    
    @IBOutlet var padMapView: MKMapView!
    
    var launch: Launch?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let launch = launch else {
            self.dismiss(animated: true, completion: nil)
            return
        }
                
        rocketNameLabel.text = launch.name
        agencyNameLabel.text = launch.launchProvider?.name
        locationNameLabel.text = launch.launchPad?.loacationName
        padNameLabel.text = launch.launchPad?.name
        latitudeLabel.text = launch.launchPad?.latitude
        longitudeLabel.text = launch.launchPad?.longitude
        
        guard let lat = Double(launch.launchPad?.latitude ?? "") else {return}
        guard let long = Double(launch.launchPad?.longitude ?? "")  else {return}
        padMapView.mapType = .satelliteFlyover
        padMapView.isScrollEnabled = false
        padMapView.isRotateEnabled = false

        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: CLLocationDistance(5000))
        padMapView.setCameraZoomRange(zoomRange, animated: true)
        padMapView.centerCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
    }
        
}
