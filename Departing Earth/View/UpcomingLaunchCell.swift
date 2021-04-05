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
    @IBOutlet var expectedLabel: UILabel!
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var logoBackgroundView: UIView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var countdownLabel: UILabel!
    @IBOutlet var countdownBackgroundView: UIView!
    
    @IBOutlet weak var logoImageViewWidthContraint: NSLayoutConstraint!
    
    var cellId: String?
    var net: String?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        logoImageView.image = nil
        cellId = nil
    }
        
    func setStyle() {
        self.layer.cornerRadius = 15
        self.layer.cornerCurve = .continuous
        self.backgroundColor = .tertiarySystemBackground
        self.logoBackgroundView.backgroundColor = .tertiarySystemBackground
        setTextStyles()
        self.launchProviderTypeLabel.textColor = Colours.spaceSuitOrange.ui
        self.countdownBackgroundView.layer.cornerRadius = 5
        self.countdownBackgroundView.layer.cornerCurve = .continuous
        self.countdownBackgroundView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
    }
    
    private func setTextStyles() {
        for label in self.cellLabels() {
            label?.textColor = UIColor.label
        }
        self.rocketNameLabel.font = Fonts.cellTitle.uiFont
        self.launchProviderNameLabel.font = Fonts.cellSmall.uiFont
        self.launchProviderTypeLabel.font = Fonts.cellBody.uiFont
        self.launchDateLabel.font = Fonts.cellBody.uiFont
        self.expectedLabel.font = Fonts.cellSmall.uiFont
        self.countdownLabel.font = Fonts.customMonospaced(14, .bold).uiFont
        self.countdownLabel.textColor = .white
    }
    
    func setDownloadingActivity(on: Bool) {
        let animationDuration: Double = on ? 0 : 0.2
        UIView.animate(withDuration: animationDuration) {
            let alpha: CGFloat = on ? 0 : 1
            self.launchDateLabel.alpha = alpha
            self.launchProviderNameLabel.alpha = alpha
            self.launchProviderTypeLabel.alpha = alpha
            self.logoImageView.alpha = alpha
            self.rocketNameLabel.alpha = alpha
            self.updateCountdown()
        }
        if on {
            self.activityIndicator.startAnimating()
        } else {
            self.activityIndicator.stopAnimating()
        }
    }
    
    func updateCountdown() {
        if let net = self.net {
            let countdownString = LaunchDateTime.countdownStringTo(isoString: net)
            self.countdownLabel.text = "T- \(countdownString)"
        } else {
            self.countdownLabel.text = "-- -- -- --"
        }
    }
    
    func setLogo(image: UIImage) {
        let imageSize = image.size
        setImageViewSize(imageSize: imageSize)
        self.logoImageView.image = image
    }
    
    private func setImageViewSize(imageSize: CGSize) {
        let height = logoImageView.frame.height
        let heightRatio = imageSize.height/height
        let width = imageSize.width/heightRatio
        if width > 200 {
            logoImageViewWidthContraint.constant = 200
        } else {
            logoImageViewWidthContraint.constant = width
        }
    }
    
    private func cellLabels() -> [UILabel?] {
        let labels = [ rocketNameLabel, launchDateLabel, launchProviderNameLabel, launchProviderTypeLabel, expectedLabel, countdownLabel]
        return labels
    }
    
}
