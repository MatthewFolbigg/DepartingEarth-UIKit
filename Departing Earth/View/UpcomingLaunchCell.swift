//
//  UpcomingLaunchCell.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 31/03/2021.
//

import Foundation
import UIKit

class UpcomingLaunchCell: UICollectionViewCell {
    @IBOutlet var rocketNameLabel: UILabel!
    @IBOutlet var launchProviderNameLabel: UILabel!
    @IBOutlet var launchProviderTypeLabel: UILabel!
    @IBOutlet var launchDateLabel: UILabel!
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    func setUpdating(on: Bool) {
        let alapha: CGFloat = on ? 0 : 1
        self.launchDateLabel.alpha = alapha
        self.launchProviderNameLabel.alpha = alapha
        self.launchProviderTypeLabel.alpha = alapha
        self.logoImageView.alpha = alapha
        self.rocketNameLabel.alpha = alapha
        if on {
            self.activityIndicator.startAnimating()
        } else {
            self.activityIndicator.stopAnimating()
        }
    }
}
