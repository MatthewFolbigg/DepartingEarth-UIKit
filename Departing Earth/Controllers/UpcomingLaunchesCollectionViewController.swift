//
//  UpcomingLaunchesTableViewController.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 31/03/2021.
//

import Foundation
import UIKit

class UpcomingLaunchesCollectionViewController: UICollectionViewController {
    
    var dataController: DataController!
    var cellSideInsetAmount: CGFloat = 30
    
    var upcomingLaunchInfo: [LaunchInfo] = []
    var launches: [Launch] = []
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        getUpcomingLaunches()
        collectionView.backgroundColor = .systemBackground
    }
    
    func getUpcomingLaunches() {
        LaunchLibraryApiClient.getUpcomingLaunches { (returnedLaunches, error, response) in
            guard let returnedLaunches = returnedLaunches else {
                return
            }
            self.upcomingLaunchInfo = returnedLaunches
            for _ in returnedLaunches {
                let blankLaunch = Launch(context: self.dataController.viewContext)
                self.launches.append(blankLaunch)
            }
            self.collectionView.reloadData()
        }
    }
    
    //MARK: UI Setup
    func setupNavigationBar() {
        navigationController?.navigationBar.layoutMargins.left = cellSideInsetAmount + 2
        //MARK: TOTO Move to global accessible font structure
        let largeTitleFont = UIFont.monospacedSystemFont(ofSize: 28, weight: .semibold)
        let smallTitleFont = UIFont.monospacedSystemFont(ofSize: 18, weight: .semibold)
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label, NSAttributedString.Key.font: largeTitleFont]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label, NSAttributedString.Key.font: smallTitleFont]
        
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
    
}

//MARK: Cells and Supplementary Views
extension UpcomingLaunchesCollectionViewController {
    
    //MARK: Cells
    
    func setLaunchContentFor(cell: UpcomingLaunchCell, atRow row: Int) {
        cell.setUpdating(on: true)
        let launchInfo = upcomingLaunchInfo[row]
        let launchId = launchInfo.id
        cell.cellId = launchId
        LaunchHelper.createLaunchObjectFrom(launchInfo: launchInfo, context: self.dataController.viewContext) { (launch) in
            if cell.cellId == launchId {
                self.launches[row] = launch
                cell.rocketNameLabel.text = launch.rocket?.name
                cell.launchDateLabel.text = LaunchDateTime.defaultDateString(isoString: launch.netDate)
                cell.launchProviderNameLabel.text = launch.launchProvider?.name
                cell.launchProviderTypeLabel.text = launch.launchProvider?.type
                guard let agency = launch.launchProvider else { return }
                AgencyHelper.getLogoFor(agency: agency, context: self.dataController.viewContext) { (image) in
                    if cell.cellId == launchId {
                        guard let data = agency.logo?.imageData else { return }
                        guard let image = UIImage(data: data) else { return }
                        cell.setLogo(image: image)
                    }
                }
                cell.setUpdating(on: false)
            }
        }
    }
    
    func setPlaceholderLogoImageFor(cell: UpcomingLaunchCell) {
        cell.logoImageView.image = UIImage(systemName: "flame")
        cell.logoImageView.tintColor = .orange
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
        itemSize.height = 200
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
