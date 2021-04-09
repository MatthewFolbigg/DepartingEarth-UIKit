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
    

    @IBOutlet var statusIndicatorImageView: UIImageView!
    @IBOutlet var dateStatusLabel: UILabel!
    @IBOutlet var countdownLabel: UILabel!
    @IBOutlet var countdownBackgroundView: UIView!
    
    @IBOutlet var dateTimeSectionBackground: UIView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var dateImageView: UIImageView!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var timeImageView: UIImageView!
    
    @IBOutlet var locationNameLabel: UILabel!
    @IBOutlet var padNameLabel: UILabel!
    @IBOutlet var mapSectionBackgroundView: UIView!
    @IBOutlet var padMapView: MKMapView!
    
    var launch: Launch!
    var launchStatus: LaunchHelper.LaunchStatus!
    let cornerRadiusConstant: CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK: UI Setup
    func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        setupBackgroundViews()
        setupFonts()
        setOrangeTints()
        
        setupCountdownSection()
        setupDateTimeSection()
        setupPadMapSection()
    }
    
    func setupBackgroundViews() {
        let backgrounds: [UIView] = [countdownBackgroundView, dateTimeSectionBackground, mapSectionBackgroundView, padMapView]
        for background in backgrounds {
            background.backgroundColor = .secondarySystemGroupedBackground
            background.layer.cornerRadius = background.frame.width/cornerRadiusConstant
            background.layer.cornerCurve = .continuous
        }
    }
    
    func setOrangeTints() {
        let itemsToTint: [UIView] = [self.navigationController!.navigationBar, dateImageView, timeImageView]
        for item in itemsToTint {
            item.tintColor = Colours.spaceSuitOrange.ui
        }
    }
    
    func setupFonts() {
        countdownLabel.font = Fonts.customMonospaced(20, .bold).uiFont
        locationNameLabel.font = Fonts.customMonospacedDigit(10, .medium).uiFont
        padNameLabel.font = Fonts.customMonospacedDigit(20, .semibold).uiFont
        dateStatusLabel.font = Fonts.customMonospaced(15, .semibold).uiFont
        dateLabel.font = Fonts.customMonospacedDigit(15, .light).uiFont
        timeLabel.font = Fonts.customMonospacedDigit(15, .light).uiFont
    }
    
    //MARK: Countdown Timer
    func setupCountdownSection() {
        setupCountdownRefreshTimer()
        updateCountdownLabel()
    }
    
    func setupCountdownRefreshTimer() {
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCountdownLabel), userInfo: nil, repeats: true)
    }
    
    @objc func updateCountdownLabel() {
        if let launch = launch {
            let countdown = LaunchDateTime.getCountdownTimerString(launch: launch)
            countdownLabel.text = countdown
        }
    }
    
    //MARK: Date Time Section
    func setupDateTimeSection() {
        statusIndicatorImageView.tintColor = launchStatus.colour
        
        dateStatusLabel.text = "\(launchStatus.countdownDescription)"
        dateLabel.text = LaunchDateTime.defaultDateString(isoString: launch.netDate)
        
        switch launchStatus {
        case .go, .success, .failure: timeLabel.text = "12:59"
        case .hold: timeLabel.text = launchStatus.description
        case .tbd: timeLabel.text = launchStatus.description
        default: timeLabel.text = ""
        }
    }
    
    
    //MARK: Pad Map
    
    func setupPadMapSection() {
        locationNameLabel.text = launch.launchPad?.loacationName
        padNameLabel.text = launch.launchPad?.name
        guard let lat = Double(launch.launchPad?.latitude ?? "") else { return }
        guard let long = Double(launch.launchPad?.longitude ?? "")  else {return }
        setMapInteractionSettings(lat: lat, long: long)
        setMapCamera(lat: lat, long: long)
    }
    
    func setMapCamera(lat: Double, long: Double) {
        let cameraRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: long), latitudinalMeters: CLLocationDistance(1000), longitudinalMeters: CLLocationDistance(1000))
        padMapView.setRegion(cameraRegion, animated: true)
    }
    
    func setMapInteractionSettings(lat: Double, long: Double) {
        padMapView.mapType = .satelliteFlyover
        padMapView.isRotateEnabled = false
        
        let cameraRegionLimit = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: long), latitudinalMeters: CLLocationDistance(8000), longitudinalMeters: CLLocationDistance(8000))
        let cameraBounds = MKMapView.CameraBoundary(coordinateRegion: cameraRegionLimit)
        padMapView.setCameraBoundary(cameraBounds, animated: false)
    }
        
}
