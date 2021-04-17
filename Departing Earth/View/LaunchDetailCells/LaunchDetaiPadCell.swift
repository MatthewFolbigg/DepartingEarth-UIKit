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
    
    @IBOutlet var openInMapsButton: UIButton!
    
    override func setupCell() {
        self.tag = 4
        guard let launch = launch else { return }
        setFontToTitle(labels: [padNameLabel])
        setFontToBody(labels: [locationNameLabel])
        openInMapsButton.tintColor = Colours.spaceSuitOrange.ui
        setRoundedCorners(view: padMapView)
        locationNameLabel.text = launch.pad?.loacationName
        padNameLabel.text = launch.pad?.name
        setupBackground()
        setupMap(launch: launch)
    }
    
    @IBAction func openInMapsButtonDidPressed() {
        guard let launch = launch else { return }
        openInMaps(launch: launch)
    }
    
    func openInMaps(launch: Launch) {
        let region = padMapView.region
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: region.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: region.span),
            MKLaunchOptionsMapTypeKey: NSNumber(2)
        ]
        guard let mapItem = mapItemForLaunch(launch: launch) else { return }
        mapItem.name = "\(launch.name ?? "Launching from"): \(launch.pad?.name ?? "Unnamed")"
        mapItem.openInMaps(launchOptions: options)
    }
    
    private func mapItemForLaunch(launch: Launch) -> MKMapItem? {
        guard let lat = Double(launch.pad?.latitude ?? "") else { return nil }
        guard let long = Double(launch.pad?.longitude ?? "")  else { return nil }
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        return mapItem
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
