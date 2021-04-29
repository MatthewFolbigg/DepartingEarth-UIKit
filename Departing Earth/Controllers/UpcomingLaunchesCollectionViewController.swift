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
    
    @IBOutlet var filterBarButtonItem: UIBarButtonItem!
    @IBOutlet var mainActivityIndicator: UIActivityIndicatorView!
    
    var launchManager: LaunchManager!
    var dataController: DataController!
    
    var cellSideInsetAmount: CGFloat = 15
    var allLaunches: [Launch] = []
    var launches: [Launch] = []
    var selectedProvider: String = "All"
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRereshControl()
        launchManager = LaunchManager(context: dataController.viewContext)
        loadUpcomingLaunches()
        setupCountdownUpdateTimer()
        setupFilterMenu()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let lastUpdate = UserDefaults.standard.object(forKey: "lastUpdated") as? Date{
            if lastUpdate.timeIntervalSinceNow < -21600 { //If last update is older than 6 hours
                print("\(#file): Updating launches because data is old")
                downloadUpcomingLaunches()
            }
        }
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
        print("\(#file) Loaded upcoming launches from CoreData")
        self.launches = launches
        self.allLaunches = self.launches
        mainActivityIndicator.stopAnimating()
        self.collectionView.refreshControl?.endRefreshing()
        collectionView.reloadData()
    }
    
    func downloadUpcomingLaunches() {
        filterBarButtonItem.isEnabled = false
        LaunchLibraryApiClient.getUpcomingLaunches { (returnedLaunches, error) in
            guard let returnedLaunches = returnedLaunches else {
                self.mainActivityIndicator.stopAnimating()
                self.collectionView.refreshControl?.endRefreshing()
                self.filterBarButtonItem.isEnabled = true
                if let error = error {
                    let fetchedLaunches = self.launchManager.fetchStoredLaunches()
                    if fetchedLaunches?.count ?? 0 > 0 {
                        self.handelFetchedLaunches(launches: fetchedLaunches!)
                    }
                    self.handleDownloadError(error: error)
                }
                return
            }
            self.launchManager.deleteStoredLaunches()
            self.launches = self.launchManager.createLaunchesFrom(results: returnedLaunches)
            UserDefaults.standard.setValue(Date(), forKey: "lastUpdated")
            self.allLaunches = self.launches
            self.collectionView.reloadData()
            self.setupFilterMenu()
            self.filterBarButtonItem.isEnabled = true
            self.mainActivityIndicator.stopAnimating()
            self.collectionView.refreshControl?.endRefreshing()
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
        filterBarButtonItem.tintColor = Colours.spaceSuitOrange.ui
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
        let title = error.localizedDescription
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        self.displayError(title: title, message: message, actions: [action])
    }
    
    //MARK: Filter Menu
    func setupFilterMenu() {
        let state: UIMenuElement.State = self.selectedProvider == "All" ? .on : .off
        let allAction = UIAction(title: "All", state: state) { (action) in
            self.selectedProvider = "All"
            self.launches = self.allLaunches
            self.setupFilterMenu()
            self.collectionView.reloadData()
        }
        var menu = UIMenu(title: "Launch Provider", image: nil, identifier: nil, options: .displayInline, children: [allAction])
        let providers = launchManager.fetchStoredProviders()
        for provider in providers ?? [] {
            if provider.launches!.count == 0 {} else {
            let state: UIMenuElement.State = provider.name == selectedProvider ? .on : .off
            let title = provider.name?.count ?? 0 < 26 ? provider.name : provider.abbreviation
            let filterAction = UIAction(title: title ?? "", state: state) { (action) in
                let filtered = self.allLaunches.filter { launch in
                    launch.provider == provider
                }
                self.launches = filtered
                self.selectedProvider = provider.name ?? ""
                self.setupFilterMenu()
                self.collectionViewLayout.invalidateLayout()
                self.collectionView.reloadData()
            }
            var children = menu.children
            children.append(filterAction)
            menu = menu.replacingChildren(children)
            }
        }
        filterBarButtonItem.menu = menu
    }
    
}

//MARK:- CollectionView Delegate and DataSource
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
        let destination = storyboard?.instantiateViewController(identifier: "LaunchDetailCollectionViewController") as! LaunchDetailCollectionViewController
        let launch = launches[indexPath.row]
        destination.launch = launch
        destination.title = nil //launch.rocket?.name
        self.navigationController?.pushViewController(destination, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "UpcomingHeader", for: indexPath) as? UpcomingLaunchesSectionHeader {
            headerCell.setupCell()
            if selectedProvider == "All" {
                headerCell.filterLabel.text = nil
            } else {
                headerCell.filterLabel.text = "\(selectedProvider)"
            }
            return headerCell
        } else {
            return UICollectionReusableView()
        }
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
    
    func setupRereshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(collectionViewRefreshControlDidActivate), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    @objc func collectionViewRefreshControlDidActivate() {
        // Gets new launches first, only deletes previous saved/shown launches if the get request is successful.
        downloadUpcomingLaunches()
        self.selectedProvider = "All"
        self.setupFilterMenu()
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        var itemSize = CGSize()
        if section == 0 {
            let collectionViewSize = collectionView.bounds.size
            var itemSize = CGSize()
            if selectedProvider == "All" {
                itemSize.height = 0
            } else {
                itemSize.height = 20
            }
            itemSize.width = collectionViewSize.width
            return itemSize
        } else {
            itemSize.height = 0
            itemSize.width = 0
            return itemSize
        }
    }
    
}
