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
    @IBOutlet var statusBackgroundView: UIView!
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
    
    var launch: Launch?
    var launchStatus: LaunchHelper.LaunchStatus?
    let cornerRadiusConstant: CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        self.navigationController?.navigationBar.tintColor = Colours.spaceSuitOrange.ui
        
        guard let launch = launch else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        guard let launchStatus = LaunchHelper.LaunchStatus(rawValue: Int(launch.statusId)) else {
            return
        }
        
        setupCountdownUpdateTimer()
        updateCountdownLabel()
    
        setupCountdownSection(launch: launch)
        setupDateTimeSection(launch: launch, launchStatus: launchStatus)
        setupPadMapViewSection(launch: launch)
        setupPadMapView(launch: launch)
        
    }
    
    //MARK: Launch Countdown Section
    func setupCountdownSection(launch: Launch) {
        
        countdownLabel.font = Fonts.customMonospaced(20, .bold).uiFont
        countdownLabel.textColor = .label
        
        countdownBackgroundView.layer.cornerRadius = countdownBackgroundView.frame.width/cornerRadiusConstant
        countdownBackgroundView.layer.cornerCurve = .continuous
        countdownBackgroundView.backgroundColor = .secondarySystemGroupedBackground
    }
    
    //MARK: Countdown Timer
    func setupCountdownUpdateTimer() {
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCountdownLabel), userInfo: nil, repeats: true)
    }
    
    @objc func updateCountdownLabel() {
        if let launch = launch {
            let countdown = LaunchDateTime.getCountdownTimerString(launch: launch)
            countdownLabel.text = countdown
        }
    }
    
    //MARK: Date Time Section
    func setupDateTimeSection(launch: Launch, launchStatus: LaunchHelper.LaunchStatus) {
        dateTimeSectionBackground.layer.cornerRadius = dateTimeSectionBackground.frame.width/cornerRadiusConstant
        dateTimeSectionBackground.layer.cornerCurve = .continuous
        
        dateStatusLabel.text = "\(launchStatus.countdownDescription)"
        dateStatusLabel.textColor = .label
        dateStatusLabel.font = Fonts.customMonospaced(15, .semibold).uiFont
        
        statusIndicatorImageView.tintColor = launchStatus.colour
        
        dateImageView.tintColor = Colours.spaceSuitOrange.ui
        timeImageView.tintColor = Colours.spaceSuitOrange.ui
        
        dateLabel.font = Fonts.customMonospacedDigit(15, .light).uiFont
        timeLabel.font = Fonts.customMonospacedDigit(15, .light).uiFont
        
        
        dateLabel.text = LaunchDateTime.defaultDateString(isoString: launch.netDate)
        
        if launchStatus == .failure || launchStatus == .success || launchStatus == .go {
            timeLabel.text = "12:59"
        } else if launchStatus == .hold {
            timeLabel.text = launchStatus.description
        } else {
            timeLabel.text = "Pending"
        }
        
        

    }
    
    
    //MARK: Pad Map
    
    func setupPadMapViewSection(launch: Launch) {
        locationNameLabel.text = launch.launchPad?.loacationName
        locationNameLabel.font = Fonts.customMonospacedDigit(10, .medium).uiFont
        padNameLabel.text = launch.launchPad?.name
        padNameLabel.font = Fonts.customMonospacedDigit(20, .semibold).uiFont
    }
    
    func setupPadMapView(launch: Launch) {
        
        mapSectionBackgroundView.backgroundColor = .secondarySystemGroupedBackground
        mapSectionBackgroundView.layer.cornerRadius = mapSectionBackgroundView.frame.width/cornerRadiusConstant
        mapSectionBackgroundView.layer.cornerCurve = .continuous
        
        padMapView.layer.cornerRadius = padMapView.frame.width/cornerRadiusConstant
        padMapView.layer.cornerCurve = .continuous
        guard let lat = Double(launch.launchPad?.latitude ?? "") else {return}
        guard let long = Double(launch.launchPad?.longitude ?? "")  else {return}
        padMapView.mapType = .satelliteFlyover
        padMapView.isRotateEnabled = false
        
        let cameraRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: long), latitudinalMeters: CLLocationDistance(500), longitudinalMeters: CLLocationDistance(500))
        let cameraRegionLimit = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: long), latitudinalMeters: CLLocationDistance(2000), longitudinalMeters: CLLocationDistance(2000))
        let cameraBounds = MKMapView.CameraBoundary(coordinateRegion: cameraRegionLimit)
        padMapView.setCameraBoundary(cameraBounds, animated: false)
        padMapView.setRegion(cameraRegion, animated: true)
    }
        
}
