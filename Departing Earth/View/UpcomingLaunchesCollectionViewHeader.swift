//
//  UpcomingLaunchesCollectionViewHeader.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 15/04/2021.
//

import Foundation
import UIKit

class UpcomingLaunchesSectionHeader: UICollectionReusableView {
    @IBOutlet var filterLabel: UILabel!
    @IBOutlet var countLabel: UILabel!

    func setupCell() {
        filterLabel.font = Fonts.cellBody.uiFont
        filterLabel.textColor = .secondaryLabel
    }
}
