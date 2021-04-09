//
//  UpcomingLaunchesTableViewController.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 31/03/2021.
//

import Foundation
import UIKit
import CoreData

class UpcomingLaunchesCollectionViewController: UICollectionViewController {
    
    @IBOutlet var refreshBarButtonItem: UIBarButtonItem!
    @IBOutlet var mainActivityIndicator: UIActivityIndicatorView!
    
    var dataController: DataController!
    var cellSideInsetAmount: CGFloat = 25
    
    var upcomingLaunchInfo: [LaunchInfo] = []
    var launches: [Launch] = []
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        getUpcomingLaunches()
        setupCountdownUpdateTimer()
        collectionView.backgroundColor = UIColor.secondarySystemBackground
        refreshBarButtonItem.tintColor = Colours.spaceSuitOrange.ui
    }
    
    //MARK: Fetching & Downloading Launch Data
    func getUpcomingLaunches() {
        mainActivityIndicator.startAnimating()
        let fetchedLaunches = LaunchHelper.fetchStoredLaunches(context: dataController.viewContext)
        if fetchedLaunches.count > 0 {
            print("Loaded upcoming from CoreData")
            self.launches = fetchedLaunches
            collectionView.reloadData()
            mainActivityIndicator.stopAnimating()
        } else {
            print("Downloading upcoming from API")
            downloadUpcomingLaunches()
        }
    }
        
    func downloadUpcomingLaunches() {
        LaunchLibraryApiClient.getUpcomingLaunches { (returnedLaunches, error) in
            if let error = error {
                self.handleError(error: error)
            }
            
            guard let returnedLaunches = returnedLaunches else {
                self.mainActivityIndicator.stopAnimating()
                return //TODO: Handel error as failed refresh/initail DL
            }
            self.upcomingLaunchInfo = returnedLaunches
            for info in returnedLaunches {
                let launch = LaunchHelper.createLaunchObjectFrom(launchInfo: info, context: self.dataController.viewContext)
                    self.launches.append(launch)
            }
            self.collectionView.reloadData()
            self.mainActivityIndicator.stopAnimating()
        }
    }
    
    func handleError(error: Error) {
        if let downloadError = error as? LaunchLibraryApiClient.downloadError {
            showUserError(error: downloadError)
        } else {
            print(error)
        }
    }
    
    func showUserError(error: Error) {
        let error = error as NSError
        let message = "\(error.localizedFailureReason ?? "")\n\(error.localizedRecoverySuggestion ?? "")"
        let alert = UIAlertController(title: error.localizedDescription, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: Countdown Refresh Timer
    func setupCountdownUpdateTimer() {
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdownUpdateTimerDidFire), userInfo: nil, repeats: true)
    }
    
    @objc func countdownUpdateTimerDidFire() {
        let visibleCells = collectionView.visibleCells
        for cell in visibleCells {
            guard let cell = cell as? UpcomingLaunchCell else { return }
            cell.updateCountdown()
        }
    }
    
    //MARK: UI Setup
    func setupNavigationBar() {
        navigationController?.navigationBar.layoutMargins.left = cellSideInsetAmount + 2
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.label,
            NSAttributedString.Key.font: Fonts.navigationTitleLarge.uiFont
        ]
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.label,
            NSAttributedString.Key.font: Fonts.navigationTitleSmall.uiFont]
    }
    
    @IBAction func refreshButtonDidTapped() {
        refreshBarButtonItem.isEnabled = false
        deleteCurrentLaunches()
        getUpcomingLaunches()
        refreshBarButtonItem.isEnabled = true
    }
    
    func deleteCurrentLaunches() {
        self.launches = []
        let storedLaunches = LaunchHelper.fetchStoredLaunches(context: dataController.viewContext)
        for launch in storedLaunches {
            dataController.viewContext.delete(launch)
        }
        try? dataController.viewContext.save()
        collectionView.reloadData()
    }
        
}

//MARK: CollectionView Delegate and DataSource
extension UpcomingLaunchesCollectionViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return launches.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LaunchCell", for: indexPath) as! UpcomingLaunchCell
        cell.setStyle()
        setLaunchContentFor(cell: cell, atRow: indexPath.row)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("DidSelectStart")
        let destination = storyboard?.instantiateViewController(identifier: "LaunchDetail") as! LaunchDetailViewController
        let launch = launches[indexPath.row]
        destination.launch = launch
        destination.title = launch.rocket?.name
        let launchStatus = LaunchHelper.LaunchStatus(rawValue: Int(launch.statusId))
        destination.launchStatus = launchStatus
        self.navigationController?.pushViewController(destination, animated: true)
        print("DidSelectEnd")
    }
}

//MARK: Cells and Supplementary Views
extension UpcomingLaunchesCollectionViewController {
    
    //MARK: Cells
    func setLaunchContentFor(cell: UpcomingLaunchCell, atRow row: Int) {
        let launch = launches[row]
        cell.launch = launch
        cell.setDownloadingActivity(on: true)
        let launchId = launch.launchId
        cell.cellId = launchId
        cell.rocketNameLabel.text = launch.rocket?.name
        let expectedLaunchDate = LaunchDateTime.launchDateString(isoString: launch.netDate)
        cell.launchDateLabel.text = expectedLaunchDate
        cell.updateCountdown()
        
        let providerId = launch.launchProviderId
        AgencyHelper.getAgencyForId(id: Int(providerId), context: dataController.viewContext) { (agency, error)  in
            guard let agency = agency else { return }
            launch.launchProvider = agency
            if cell.cellId == launchId {
                cell.launchProviderNameLabel.text = launch.launchProvider?.name
                cell.launchProviderTypeLabel.text = launch.launchProvider?.type ?? "Unspecified"
            }
            AgencyHelper.getLogoFor(agency: agency, context: self.dataController.viewContext) { (image, error) in
                if cell.cellId == launchId {
                    guard let data = agency.logo?.imageData else {
                        let placeholder = UIImage(systemName: "rectangle.dashed")!
                        cell.logoImageView.tintColor = Colours.spaceSuitOrange.ui
                        cell.setLogo(image: placeholder)
                        return
                    }
                    guard let image = UIImage(data: data) else {
                        let placeholder = UIImage(systemName: "rectangle.dashed")!
                        cell.logoImageView.tintColor = Colours.spaceSuitOrange.ui
                        cell.setLogo(image: placeholder)
                        return
                    }
                    cell.setLogo(image: image)
                }
            }
        }
        cell.setDownloadingActivity(on: false)
    }
}

//MARK: CollectionView FlowLayout
extension UpcomingLaunchesCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = calculateUpcomingLaunchCellSize()
        return itemSize
    }
    
    func calculateUpcomingLaunchCellSize() -> CGSize{
        let collectionViewSize = collectionView.bounds.size
        var itemSize = CGSize()
        itemSize.height = 220
        itemSize.width = collectionViewSize.width - (cellSideInsetAmount * 2)
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let insetAmount: CGFloat = cellSideInsetAmount
        let edgeInsets = UIEdgeInsets(top: 10, left: insetAmount, bottom: 10, right: insetAmount)
        return edgeInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
}
