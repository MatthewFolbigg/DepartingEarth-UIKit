//
//  LaunchDetailCollectionViewController.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 15/04/2021.
//

import Foundation
import UIKit
import EventKit
import EventKitUI
import MapKit

class LaunchDetailCollectionViewController: UICollectionViewController {
    var launch: Launch!
    var statusController: StatusController!
    let eventStore = EKEventStore()
    var cellSideInsetAmount: CGFloat = 10
    
    enum detailSections: Int {
        case title = 0
        case countdown = 1
        case dateTime = 2
        case mission = 3
        case pad = 4
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statusController = StatusController(launch: launch)
        self.navigationController!.navigationBar.tintColor = Colours.spaceSuitOrange.ui
        collectionView.backgroundColor = .systemGroupedBackground
        //collectionView.backgroundColor = .systemBackground
        setupCountdownUpdateTimer()
    }
        
    //MARK: Countdown Refresh Timer
    func setupCountdownUpdateTimer() {
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdownUpdateTimerDidFire), userInfo: nil, repeats: true)
    }
    
    @objc func countdownUpdateTimerDidFire() {
        let cell = collectionView.cellForItem(at: IndexPath(row: detailSections.countdown.rawValue, section: 0))
        guard let countdownCell = cell as? LaunchDetailCountdownCell else { return }
        guard let launch = countdownCell.launch else { return }
        guard let status = countdownCell.status else { return }
        countdownCell.updateCountdown(launch: launch, status: status)
    }
}

//MARK: Calander Events
extension LaunchDetailCollectionViewController: EKEventEditViewDelegate, UINavigationControllerDelegate, CalendarCellDelegate {
    
    func didTapAddToCalButton(launch: Launch) {
        presentEventEditViewControllerWithLauchDetails()
    }
    
    @IBAction func addToCalButtonDidPressed() {
        presentEventEditViewControllerWithLauchDetails()
    }

    func presentEventEditViewControllerWithLauchDetails() {
        eventStore.requestAccess(to: .event) { granted, error in
            DispatchQueue.main.async {
                guard granted, error == nil else {
                    let message = "To add launch events to a calendar this app needs permission to access your calendars. If you would like to use the add to calendar button please update your privacy settings."
                    let alert = UIAlertController(title: "No Calendar Access", message: message, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Not Right Now", style: .cancel, handler: nil)
                    let settingsAction = UIAlertAction(title: "Settings", style: .default) {_ in
                        let url = URL(string: UIApplication.openSettingsURLString)!
                        UIApplication.shared.canOpenURL(url)
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                    alert.addAction(okAction)
                    alert.addAction(settingsAction)
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                let launchEvent = self.eventForLaunch()
                let eventVC = EKEventEditViewController()
                eventVC.delegate = self
                eventVC.editViewDelegate = self
                eventVC.eventStore = self.eventStore
                eventVC.event = launchEvent
                self.present(eventVC, animated: true, completion: nil)
            }
        }
    }
    
    private func eventForLaunch() -> EKEvent {
        let launchEvent = EKEvent(eventStore: eventStore)
        launchEvent.title = launch.name
        launchEvent.isAllDay = true
        launchEvent.startDate = launch.date
        launchEvent.endDate = launch.date
        launchEvent.calendar = eventStore.defaultCalendarForNewEvents
        launchEvent.notes = launch.mission?.objectives
        if let mapItem = mapItemForCalendar(launch: self.launch) {
            mapItem.name = "\(launch.pad?.name ?? "Unnamed Pad")"
            launchEvent.structuredLocation = EKStructuredLocation(mapItem: mapItem)
        }
        return launchEvent
    }
    
    private func mapItemForCalendar(launch: Launch) -> MKMapItem? {
        guard let lat = Double(launch.pad?.latitude ?? "") else { return nil }
        guard let long = Double(launch.pad?.longitude ?? "")  else { return nil }
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        return mapItem
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

//MARK: CollectionView Delegate
extension LaunchDetailCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //TODO: Is there a better way to do this with generics?
        if indexPath.row == detailSections.title.rawValue {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LaunchDetailTitleCell", for: indexPath) as? LaunchDetailTitleCell {
                cell.launch = launch
                cell.status = statusController
                cell.setupCell()
                return cell
            }
        }
        
        if indexPath.row == detailSections.countdown.rawValue {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LaunchDetailCountdownCell", for: indexPath) as? LaunchDetailCountdownCell {
                cell.launch = launch
                cell.status = statusController
                cell.updateCountdown(launch: launch, status: statusController)
                cell.setupCell()
                return cell
            }
        }
        
        if indexPath.row == detailSections.dateTime.rawValue {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LaunchDetailDateCell", for: indexPath) as? LaunchDetailDateCell {
                cell.launch = launch
                cell.status = statusController
                cell.delegate = self
                cell.setupCell()
                return cell
            }
        }
        
        if indexPath.row == detailSections.mission.rawValue {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LaunchDetailMissionCell", for: indexPath) as? LaunchDetailMissionCell {
                cell.launch = launch
                cell.status = statusController
                cell.setupCell()
                return cell
            }
        }
        
        if indexPath.row == detailSections.pad.rawValue {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LaunchDetailPadCell", for: indexPath) as? LaunchDetailPadCell {
                cell.launch = launch
                cell.status = statusController
                cell.setupCell()
                return cell
            }
        }
        
        return UICollectionViewCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == detailSections.mission.rawValue {
            let destination = storyboard?.instantiateViewController(identifier: "missionDetailViewController") as! MissionDetailViewController
            guard let mission = launch.mission else { return }
            destination.mission = mission
            present(destination, animated: true, completion: nil)
        }
        if indexPath.row == detailSections.pad.rawValue {
            if let cell = collectionView.cellForItem(at: indexPath) as? LaunchDetailPadCell {
                guard let launch = launch else { return }
                cell.openInMaps(launch: launch)
            }
            
        }
    }
    
}

//MARK: CollectionView FlowLayout
extension LaunchDetailCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var itemSize = defaultCellSize()
        
        if indexPath.row == detailSections.title.rawValue { itemSize.height = 80 }
        if indexPath.row == detailSections.countdown.rawValue { itemSize.height = 80 }
        if indexPath.row == detailSections.dateTime.rawValue { itemSize.height = 90 }
        if indexPath.row == detailSections.mission.rawValue { itemSize.height = 122 }
        if indexPath.row == detailSections.pad.rawValue { itemSize.height = 400 }
        return itemSize
    }
    
    func defaultCellSize() -> CGSize {
        let collectionViewSize = collectionView.bounds.size
        var itemSize = CGSize()
        itemSize.height = 130
        itemSize.width = collectionViewSize.width - (cellSideInsetAmount * 2)
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let edgeInsets = UIEdgeInsets(top: 5, left: cellSideInsetAmount, bottom: 10, right: cellSideInsetAmount)
        return edgeInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
}

