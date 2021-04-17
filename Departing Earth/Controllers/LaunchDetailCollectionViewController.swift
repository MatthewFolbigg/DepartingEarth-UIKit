//
//  LaunchDetailCollectionViewController.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 15/04/2021.
//

import Foundation
import UIKit

class LaunchDetailCollectionViewController: UICollectionViewController {
    var launch: Launch!
    var statusController: StatusController!
    var cellSideInsetAmount: CGFloat = 8
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statusController = StatusController(launch: launch)
        self.navigationController!.navigationBar.tintColor = Colours.spaceSuitOrange.ui
        //collectionView.backgroundColor = .secondarySystemGroupedBackground
        setupCountdownUpdateTimer()
    }
    
    //MARK: Countdown Refresh Timer
    func setupCountdownUpdateTimer() {
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdownUpdateTimerDidFire), userInfo: nil, repeats: true)
    }
    
    @objc func countdownUpdateTimerDidFire() {
        let firstCell = collectionView.cellForItem(at: IndexPath(row: 0, section: 0))
        guard let countdownCell = firstCell as? LaunchDetailCountdownCell else { return }
        guard let launch = countdownCell.launch else { return }
        guard let status = countdownCell.status else { return }
        countdownCell.updateCountdown(launch: launch, status: status)
    }
    
    //MARK: Buttons
    @IBAction func addToCalButtonDidPressed() {
        print("CAL")
    }
    
}

//MARK: CollectionView Delegate
extension LaunchDetailCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LaunchDetailCountdownCell", for: indexPath) as? LaunchDetailCountdownCell {
                cell.launch = launch
                cell.status = statusController
                cell.updateCountdown(launch: launch, status: statusController)
                cell.setupCell()
                return cell
            }
        }
        
        if indexPath.row == 1 {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LaunchDetailDateCell", for: indexPath) as? LaunchDetailDateCell {
                cell.launch = launch
                cell.status = statusController
                cell.setupCell()
                return cell
            }
        }
        
        if indexPath.row == 2 {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LaunchDetailMissionCell", for: indexPath) as? LaunchDetailMissionCell {
                cell.launch = launch
                cell.status = statusController
                cell.setupCell()
                return cell
            }
        }
        
        if indexPath.row == 3 {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LaunchDetailPadCell", for: indexPath) as? LaunchDetailPadCell {
                cell.launch = launch
                cell.status = statusController
                cell.setupCell()
                return cell
            }
        }
        
        return UICollectionViewCell()
    }
}

//MARK: CollectionView FlowLayout
extension LaunchDetailCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var itemSize = defaultCellSize()
        
        if indexPath.row == 0 { itemSize.height = 80 }
        if indexPath.row == 1 { itemSize.height = 90 }
        if indexPath.row == 2 { itemSize.height = 122 }
        if indexPath.row == 3 { itemSize.height = 400 }
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
        let edgeInsets = UIEdgeInsets(top: 8, left: cellSideInsetAmount, bottom: 10, right: cellSideInsetAmount)
        return edgeInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
}

