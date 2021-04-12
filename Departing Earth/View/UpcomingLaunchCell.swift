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
    @IBOutlet var providerNameLabel: UILabel!
    @IBOutlet var providerTypeLabel: UILabel!
    @IBOutlet var launchDateLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var logoBackgroundView: UIView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var countdownLabel: UILabel!
    @IBOutlet var countdownBackgroundView: UIView!
    @IBOutlet var statusImageView: UIImageView!
    @IBOutlet var humanIconImageView: UIImageView!
    
    var labels: [UILabel] { [ rocketNameLabel, launchDateLabel, providerNameLabel, providerTypeLabel, statusLabel, countdownLabel] }
    
    var cellId: String?
    var launch: Launch?
        
    override func prepareForReuse() {
        super.prepareForReuse()
        providerNameLabel.text = nil
        providerTypeLabel.text = nil
        humanIconImageView.isHidden = true
        cellId = nil
    }
       
    //MARK: Setting UI
    func setStyle() {
        self.layer.cornerRadius = 15
        self.layer.cornerCurve = .continuous
        self.backgroundColor = .tertiarySystemBackground
        self.logoBackgroundView.backgroundColor = UIColor.white.withAlphaComponent(0.3) //.tertiarySystemBackground
        setTextStyles()
        self.providerTypeLabel.textColor = Colours.spaceSuitOrange.ui
        self.countdownBackgroundView.layer.cornerRadius = 5
        self.countdownBackgroundView.layer.cornerCurve = .continuous
        self.countdownBackgroundView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
    }
    
    private func setTextStyles() {
        for label in self.labels {
            label.textColor = UIColor.label
        }
        self.rocketNameLabel.font = Fonts.cellTitle.uiFont
        self.providerNameLabel.font = Fonts.cellSmall.uiFont
        self.providerTypeLabel.font = Fonts.cellBody.uiFont
        self.launchDateLabel.font = Fonts.cellBody.uiFont
        self.statusLabel.font = Fonts.cellSmall.uiFont
        self.countdownLabel.font = Fonts.customMonospaced(14, .bold).uiFont
        self.countdownLabel.textColor = .white
    }
    
    //MARK: Setting for Launch
    func updateCountdown() {
        guard let launch = launch else { return }
        let statusController = StatusController(launch: launch)
        if launch.isPendingDate || launch.isPendingTime { self.countdownBackgroundView.backgroundColor = Colours.moonSurfaceGrey.ui }
        self.countdownLabel.text =
            "T- \(statusController.countdownComponents.days) \(statusController.countdownComponents.hours) \(statusController.countdownComponents.minutes) \(statusController.countdownComponents.seconds)"
    }
                
    func updateStatusSpecificUI() {
        guard let launch = launch else { return }
        let statusController = StatusController(launch: launch)
        statusLabel.text = statusController.dateDescription
        statusImageView.tintColor = statusController.color
        countdownBackgroundView.backgroundColor = statusController.secondaryColor
        if let mission = launch.mission {
            if mission.type == "Human Exploration" {
                humanIconImageView.isHidden = false
            }
        }
    }
    
    //MARK: Activity Indicators
    func setDownloadingActivity(on: Bool) {
        let animationDuration: Double = on ? 0 : 0.2
        UIView.animate(withDuration: animationDuration) {
            let alpha: CGFloat = on ? 0 : 1
            self.launchDateLabel.alpha = alpha
            self.providerNameLabel.alpha = alpha
            self.providerTypeLabel.alpha = alpha
            self.rocketNameLabel.alpha = alpha
            self.updateCountdown()
        }
        if on {
            self.activityIndicator.startAnimating()
        } else {
            self.activityIndicator.stopAnimating()
        }
    }
}
