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
    
    var launchManager: LaunchManager!
    var dataController: DataController!
    
    var cellSideInsetAmount: CGFloat = 15
    var launches: [Launch] = []
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        launchManager = LaunchManager(context: dataController.viewContext)
        loadUpcomingLaunches()
        setupCountdownUpdateTimer()
    }
        
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super .viewWillTransition(to: size, with: coordinator)
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        flowLayout.invalidateLayout()
    }
    
    //MARK: Fetching & Downloading Launch Data
    func loadUpcomingLaunches() {
        mainActivityIndicator.startAnimating()
        let fetchedLaunches = launchManager.fetchStoredLaunches()
        if fetchedLaunches?.count ?? 0 > 0 {
            handelFetchedLaunches(launches: fetchedLaunches!)
        } else {
            downloadUpcomingLaunches()
        }
    }
    
    func handelFetchedLaunches(launches: [Launch]) {
        print("Loaded upcoming launches from CoreData")
        self.launches = launches
        mainActivityIndicator.stopAnimating()
        collectionView.reloadData()
    }
    
    func downloadUpcomingLaunches() {
        refreshBarButtonItem.isEnabled = false
        LaunchLibraryApiClient.getUpcomingLaunches { (returnedLaunches, error) in
            guard let returnedLaunches = returnedLaunches else {
                self.mainActivityIndicator.stopAnimating()
                self.refreshBarButtonItem.isEnabled = true
                if let error = error {
                    let fetchedLaunches = self.launchManager.fetchStoredLaunches()
                    if fetchedLaunches?.count ?? 0 > 0 {
                        self.handelFetchedLaunches(launches: fetchedLaunches!)
                    }
                    self.handleDownloadError(error: error)
                }
                return
            }
            self.mainActivityIndicator.stopAnimating()
            self.launchManager.deleteStoredLaunches()
            self.launches = self.launchManager.createLaunchesFrom(results: returnedLaunches)
            self.collectionView.reloadData()
            self.refreshBarButtonItem.isEnabled = true
            self.mainActivityIndicator.stopAnimating()
        }
    }
    
    func handleDownloadError(error: Error) {
        if let downloadError = error as? LaunchLibraryApiClient.downloadError {
            showUserError(error: downloadError)
        } else {
            print(error)
        }
    }
        
    //MARK: Countdown Refresh Timer
    func setupCountdownUpdateTimer() {
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdownUpdateTimerDidFire), userInfo: nil, repeats: true)
    }
    
    @objc func countdownUpdateTimerDidFire() {
        let visibleCells = collectionView.visibleCells
        for cell in visibleCells {
            guard let cell = cell as? LaunchCell else { return }
            guard let launch = cell.launch else { return }
            guard let status = cell.statusController else { return }
            cell.updateCountdown(launch: launch, status: status)
        }
    }
    
    //MARK: UI
    func setupUI() {
        setupNavigationBar()
        setupCollectionViewUI()
        refreshBarButtonItem.tintColor = Colours.spaceSuitOrange.ui
    }
    
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
    
    func setupCollectionViewUI() {
        collectionView.backgroundColor = UIColor.systemGroupedBackground
        collectionView.contentInsetAdjustmentBehavior = .always
    }
    
    func showUserError(error: Error) {
        let error = error as NSError
        let message = "\(error.localizedFailureReason ?? "")\n\(error.localizedRecoverySuggestion ?? "")"
        let alert = UIAlertController(title: error.localizedDescription, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: IB Actions
    @IBAction func refreshButtonDidTapped() {
        // Gets new launches first, only deletes previous saved/shown launches if the get request is successful.
        self.launches = []
        collectionView.reloadData()
        mainActivityIndicator.startAnimating()
        downloadUpcomingLaunches()
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LaunchCell", for: indexPath) as! LaunchCell
        cell.setupCell()
        setLaunchContentFor(cell: cell, atRow: indexPath.row)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destination = storyboard?.instantiateViewController(identifier: "LaunchDetail") as! LaunchDetailViewController
        let launch = launches[indexPath.row]
        destination.launch = launch
        destination.title = launch.rocket?.name
        self.navigationController?.pushViewController(destination, animated: true)
    }
}

//MARK: Cells and Supplementary Views
extension UpcomingLaunchesCollectionViewController {
    
    //MARK: Cells
    func setLaunchContentFor(cell: LaunchCell, atRow row: Int) {
        let launch = launches[row]
        let statusController = StatusController(launch: launch)
        cell.launch = launch
        cell.statusController = statusController
        cell.setupCell()
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
        itemSize.height = 175
        itemSize.width = collectionViewSize.width - (cellSideInsetAmount * 2)
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let edgeInsets = UIEdgeInsets(top: 10, left: cellSideInsetAmount, bottom: 10, right: cellSideInsetAmount)
        return edgeInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
}
