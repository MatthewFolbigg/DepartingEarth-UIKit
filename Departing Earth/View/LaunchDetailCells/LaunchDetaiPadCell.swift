//
//  LaunchDetaiPadCell.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 17/04/2021.
//

import Foundation
import UIKit
import MapKit

class LaunchDetailPadCell: LaunchDetailCell {
    
    @IBOutlet var locationNameLabel: UILabel!
    @IBOutlet var padNameLabel: UILabel!
    @IBOutlet var padMapView: MKMapView!
    
    override func setupCell() {
        self.tag = 4
        guard let launch = launch else { return }
        setFontToTitle(labels: [padNameLabel])
        setFontToBody(labels: [locationNameLabel])
        locationNameLabel.text = launch.pad?.loacationName
        padNameLabel.text = launch.pad?.name
        setupBackground()
        setupMap(launch: launch)
    }
    
    func setupMap(launch: Launch) {
        guard let lat = Double(launch.pad?.latitude ?? "") else { return }
        guard let long = Double(launch.pad?.longitude ?? "")  else {return }
        setMapInteractionSettings(lat: lat, long: long)
        setMapCamera(lat: lat, long: long)
    }
    
    private func setMapCamera(lat: Double, long: Double) {
        let cameraRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: long), latitudinalMeters: CLLocationDistance(1000), longitudinalMeters: CLLocationDistance(1000))
        padMapView.setRegion(cameraRegion, animated: true)
    }
    
    private func setMapInteractionSettings(lat: Double, long: Double) {
        padMapView.mapType = .satelliteFlyover
        padMapView.isRotateEnabled = false
        
        let cameraRegionLimit = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: long), latitudinalMeters: CLLocationDistance(8000), longitudinalMeters: CLLocationDistance(8000))
        let cameraBounds = MKMapView.CameraBoundary(coordinateRegion: cameraRegionLimit)
        padMapView.setCameraBoundary(cameraBounds, animated: false)
    }
    
}
