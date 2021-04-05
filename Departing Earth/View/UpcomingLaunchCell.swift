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
    @IBOutlet var logoBackgroundView: UIView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var logoImageViewHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var logoImageViewWidthContraint: NSLayoutConstraint!
    
    var cellId: String?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        logoImageView.image = nil
        cellId = nil
    }
    
    func setStyle() {
        self.layer.cornerRadius = 15
        self.layer.cornerCurve = .continuous
        self.backgroundColor = .tertiarySystemBackground
        self.logoBackgroundView.backgroundColor = .white
        setTextStyles()
        self.launchProviderTypeLabel.textColor = Colours.spaceSuitOrange.ui
    }
    
    func setTextStyles() {
        for label in self.cellLabels() {
            label?.textColor = UIColor.label
        }
        self.rocketNameLabel.font = UIFont.monospacedSystemFont(ofSize: 20, weight: .semibold)
        self.launchProviderNameLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 10, weight: .light)
        self.launchProviderTypeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 15, weight: .medium)
        self.launchDateLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 15, weight: .medium)
    }
    
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
    
    func setLogo(image: UIImage) {
        let imageSize = image.size
        setImageViewSize(imageSize: imageSize)
        self.logoImageView.image = image
    }
    
    func setImageViewSize(imageSize: CGSize) {
        let height = logoImageViewHeightContraint.constant
        let heightRatio = imageSize.height/height
        let width = imageSize.width/heightRatio
        if width > 200 {
            logoImageViewWidthContraint.constant = 200
        } else {
            logoImageViewWidthContraint.constant = width
        }
    }
    
    func cellLabels() -> [UILabel?] {
        let labels = [
            rocketNameLabel,
            launchDateLabel,
            launchProviderNameLabel,
            launchProviderTypeLabel
        ]
        return labels
    }
}
