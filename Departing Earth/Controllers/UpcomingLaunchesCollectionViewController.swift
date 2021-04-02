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
        getUpcomingLaunches()
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
        setStyleFor(cell: cell)
        setContentFor(cell: cell, atRow: indexPath.row)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            var header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "UpcomingHeader", for: indexPath) as! UpcomingCollectionHeaderView
            header = setUpcomingHeaderStyle(for: header)
            return header
        } else {
            return UICollectionReusableView()
        }
    }
    
}

//MARK: Cells and Supplementary Views
extension UpcomingLaunchesCollectionViewController {
    
    //MARK: Cells
    func setStyleFor(cell: UpcomingLaunchCell) {
        cell.backgroundColor = .systemGray5
        cell.layer.cornerRadius = 15
        cell.layer.cornerCurve = .continuous
    }
    
    func setContentFor(cell: UpcomingLaunchCell, atRow row: Int) {
        cell.setUpdating(on: true)
        cell.logoImageView.image = nil
        let launchInfo = upcomingLaunchInfo[row]
        LaunchHelper.createLaunchObjectFrom(launchInfo: launchInfo, context: self.dataController.viewContext) { (launch) in
            self.launches[row] = launch
            
            cell.rocketNameLabel.text = launch.rocket?.name
            cell.launchDateLabel.text = LaunchDateTime.defaultDateString(isoString: launch.netDate)
            cell.launchProviderNameLabel.text = launch.launchProvider?.abbreviation
            cell.launchProviderTypeLabel.text = launch.launchProvider?.type
            guard let agency = launch.launchProvider else { return }
            AgencyHelper.getLogoFor(agency: agency, context: self.dataController.viewContext) { (image) in
                if let imageData = agency.logo?.imageData {
                    cell.logoImageView.image = UIImage(data: imageData)
                } else {
                    self.setPlaceholderLogoImageFor(cell: cell)
                }
            }
            cell.setUpdating(on: false)
        }
    }
    
    func setPlaceholderLogoImageFor(cell: UpcomingLaunchCell) {
        cell.logoImageView.image = UIImage(systemName: "flame")
        cell.logoImageView.tintColor = .orange
    }
        
    //MARK: Headers
    func setUpcomingHeaderStyle(for view: UpcomingCollectionHeaderView) -> UpcomingCollectionHeaderView {
        view.title.text = "Departing Soon"
        view.titleLeadingContraint.constant = cellSideInsetAmount
        view.titleTrailingContraint.constant = cellSideInsetAmount
        return view
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
        itemSize.height = 150
        itemSize.width = collectionViewSize.width - (cellSideInsetAmount * 2)
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let insetAmount: CGFloat = cellSideInsetAmount
        let edgeInsets = UIEdgeInsets(top: 5, left: insetAmount, bottom: 10, right: insetAmount)
        return edgeInsets
    }
    
}
