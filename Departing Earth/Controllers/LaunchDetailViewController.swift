//
//  LaunchDetailViewController.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 05/04/2021.
//

import Foundation
import UIKit
import MapKit
import EventKit
import EventKitUI

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
    @IBOutlet var addToCalendarButton: UIButton!
    
    @IBOutlet var missionSectionBackground: UIView!
    @IBOutlet var missionNameLabel: UILabel!
    @IBOutlet var missionTypeLabel: UILabel!
    @IBOutlet var orbitNameLabel: UILabel!
    @IBOutlet var orbitNameImageView: UIImageView!
    @IBOutlet var missionTypeImageView: UIImageView!
    @IBOutlet var missionInformationButton: UIButton!
    
    @IBOutlet var locationNameLabel: UILabel!
    @IBOutlet var padNameLabel: UILabel!
    @IBOutlet var mapSectionBackgroundView: UIView!
    @IBOutlet var padMapView: MKMapView!
    @IBOutlet var openInMapsButton: UIButton!
    
    var launch: Launch!
    var statusController: StatusController!
    let cornerRadiusConstant: CGFloat = 20
    let eventStore = EKEventStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statusController = StatusController(launch: launch)
        setupUI()
        guard let mission = launch.mission else {
            return
        }
        missionNameLabel.text = mission.name ?? "Pending"
        missionTypeLabel.text = mission.type ?? "Pending"
        orbitNameLabel.text = mission.orbit?.name ?? "Pending"
        if mission.objectives == nil {
            missionInformationButton.isEnabled = false
            missionInformationButton.tintColor = .gray
        }
    }
    
    //MARK: IB Actions
    @IBAction func openInMapsButtonDidPressed() {
        //TODO: Set up a placemark that can be passed to open in maps intead of having to unwrap lat long twice (here and setup)
        guard let lat = Double(launch.pad?.latitude ?? "") else { return }
        guard let long = Double(launch.pad?.longitude ?? "")  else {return }
        openInMaps(lat: lat, Long: long)
    }
   
    @IBAction func addToCalendarButtonDidPressed() {
        createCalendarEvent()
    }
    
    @IBAction func missionInfoButtonDidPressed() {
        if let mission = launch.mission {
            let destination = storyboard?.instantiateViewController(identifier: "missionDetailViewController") as! MissionDetailViewController
            destination.mission = mission
            present(destination, animated: true, completion: nil)
        }
    }
    
    func mapItemForLaunch() -> MKMapItem? {
        guard let lat = Double(launch.pad?.latitude ?? "") else { return nil }
        guard let long = Double(launch.pad?.longitude ?? "")  else { return nil }
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        return mapItem
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
        let backgrounds: [UIView] = [countdownBackgroundView, dateTimeSectionBackground, missionSectionBackground, mapSectionBackgroundView, padMapView]
        for background in backgrounds {
            background.backgroundColor = .secondarySystemGroupedBackground
            background.layer.cornerRadius = background.frame.width/cornerRadiusConstant
            background.layer.cornerCurve = .continuous
        }
    }
    
    func setOrangeTints() {
        let itemsToTint: [UIView] = [
            self.navigationController!.navigationBar,
            dateImageView,
            timeImageView,
            openInMapsButton,
            addToCalendarButton,
            orbitNameImageView,
            orbitNameImageView,
            missionInformationButton
        ]
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
        missionNameLabel.font = Fonts.customMonospaced(15, .semibold).uiFont
        missionTypeLabel.font = Fonts.customMonospacedDigit(15, .light).uiFont
        orbitNameLabel.font = Fonts.customMonospacedDigit(15, .light).uiFont
    }
    
    //MARK: Countdown Section
    func setupCountdownSection() {
        setupCountdownRefreshTimer()
        updateCountdownLabel()
    }
    
    func setupCountdownRefreshTimer() {
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCountdownLabel), userInfo: nil, repeats: true)
    }
    
    @objc func updateCountdownLabel() {
        countdownLabel.text = "T- \(statusController.countdownComponents.days) \(statusController.countdownComponents.hours) \(statusController.countdownComponents.minutes) \(statusController.countdownComponents.seconds)"
    }
    
    //MARK: Date Time Section
    func setupDateTimeSection() {
        dateLabel.text = statusController.launchDate
        dateStatusLabel.text = statusController.launchDescription
        statusIndicatorImageView.tintColor = statusController.color
        timeLabel.text = statusController.launchTime
    }
        
    //MARK: Pad Map
    func setupPadMapSection() {
        locationNameLabel.text = launch.pad?.loacationName
        padNameLabel.text = launch.pad?.name
        guard let lat = Double(launch.pad?.latitude ?? "") else { return }
        guard let long = Double(launch.pad?.longitude ?? "")  else {return }
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
    
    func openInMaps(lat: Double, Long: Double) {
        let region = padMapView.region
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: region.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: region.span)
        ]
        guard let mapItem = mapItemForLaunch() else { return }
        mapItem.name = "\(launch.name ?? "Launching from"): \(launch.pad?.name ?? "Unnamed")"
        mapItem.openInMaps(launchOptions: options)
    }
}

extension LaunchDetailViewController: EKEventEditViewDelegate, UINavigationControllerDelegate {
    //TODO: Once access is granted refresh. Currently requires reloading the eventeditview before access is recognised
    func createCalendarEvent() {
        eventStore.requestAccess(to: .event) { granted, error in
            guard granted else {
                print(error ?? "Access to cal not granted")
                return
            }
        }
        let launchEvent = EKEvent(eventStore: eventStore)
        launchEvent.title = launch.name
        launchEvent.isAllDay = true
        launchEvent.startDate = launch.date
        launchEvent.endDate = launch.date
        launchEvent.calendar = eventStore.defaultCalendarForNewEvents
        launchEvent.notes = "Launch Notes"
        if let mapItem = mapItemForLaunch() {
            mapItem.name = "\(launch.pad?.name ?? "Unnamed Pad")"
            launchEvent.structuredLocation = EKStructuredLocation(mapItem: mapItem)
        }
        
        let eventVC = EKEventEditViewController()
        eventVC.delegate = self
        eventVC.editViewDelegate = self
        eventVC.eventStore = eventStore
        eventVC.event = launchEvent
    
        self.present(eventVC, animated: true, completion: nil)
    }
    
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        switch action {
        case .saved:
            print("Event Saved")
            controller.dismiss(animated: true, completion: nil)
        case .canceled:
            print("Canceled adding")
            controller.dismiss(animated: true, completion: nil)
        default:
            controller.dismiss(animated: true, completion: nil)
        }
    }
    
}
