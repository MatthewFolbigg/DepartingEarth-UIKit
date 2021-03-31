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
            for launchInfo in returnedLaunches {
                let launch = ModelHelpers.createLaunchObjectFrom(launchInfo: launchInfo, context: self.dataController.viewContext)
                self.launches.append(launch)
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
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LaunchCell", for: indexPath) as! UpcomingLaunchCell
        cell = setStyleFor(cell: cell)
        cell = setContentFor(cell: cell, atRow: indexPath.row)
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
    
    //MARK: Cell/Header UI Style and Content
    func setStyleFor(cell: UpcomingLaunchCell) -> UpcomingLaunchCell {
        cell.backgroundColor = .systemGray5
        cell.layer.cornerRadius = 15
        cell.layer.cornerCurve = .continuous
        return cell
    }
    
    func setUpcomingHeaderStyle(for view: UpcomingCollectionHeaderView) -> UpcomingCollectionHeaderView {
        view.title.text = "Departing Soon..."
        view.titleLeadingContraint.constant = cellSideInsetAmount
        view.titleTrailingContraint.constant = cellSideInsetAmount
        return view
    }
    
    //MARK: Cell Content
    func setContentFor(cell: UpcomingLaunchCell, atRow row: Int) -> UpcomingLaunchCell {
        let launch = launches[row]
        cell.rocketNameLabel.text = launch.rocket?.name
        cell.launchProviderNameLabel.text = launch.launchProvider?.name
        cell.launchProviderTypeLabel.text = launch.launchProvider?.type
        return cell
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
        itemSize.height = 120
        itemSize.width = collectionViewSize.width - (cellSideInsetAmount * 2)
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let insetAmount: CGFloat = cellSideInsetAmount
        let edgeInsets = UIEdgeInsets(top: 5, left: insetAmount, bottom: 10, right: insetAmount)
        return edgeInsets
    }
    
}
