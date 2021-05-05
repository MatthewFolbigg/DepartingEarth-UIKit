//
//  LaunchCell.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 13/04/2021.
//

import Foundation
import UIKit

class LaunchCell: UICollectionViewCell {
    //MARK: Cell IBOutlets
    
    //MARK: Countdown IBOutlets
    @IBOutlet var daysLabel: UILabel!
    @IBOutlet var hoursLabel: UILabel!
    @IBOutlet var minutesLabel: UILabel!
    @IBOutlet var secondsLabel: UILabel!
    @IBOutlet var countdownLabels: [UILabel]!
    @IBOutlet var countdownTitleLabels: [UILabel]!
    
    @IBOutlet var countdownBackgroundViews: [UIView]!
    @IBOutlet var statusColorView: UIView!
    @IBOutlet var tMinusPlusLabel: UILabel!
    @IBOutlet var tMinusPlusBackgroundView: UIView!
 
    //MARK: Other IBOutlets
    @IBOutlet var rocketNameLabel: UILabel!
    @IBOutlet var providerNameLabel: UILabel!
    @IBOutlet var launchDateLabel: UILabel!
    @IBOutlet var launchDateDescriptionLabel: UILabel!
    @IBOutlet var missionTypeIconImageView: UIImageView!
    @IBOutlet var missionTypeIconBackgroundView: UIView!
    
    var launch: Launch?
    var statusController: StatusController?
    var cornerRadiusConstant: CGFloat = 30
    var countdownBackgrounds: [UIView]?
    
    //MARK:-
    override func prepareForReuse() {
        missionTypeIconBackgroundView.isHidden = true
    }
    
    func setupCell() {
        guard let launch = launch else { return }
        guard let statusController = statusController else { return }
        setupBackground()
        setupCountdown()
        updateLabelText(launch: launch)
        updateCountdown(launch: launch, status: statusController)
        setupMissionTypeIcon(launch: launch)
    }
    
    private func setupMissionTypeIcon(launch: Launch) {
        missionTypeIconBackgroundView.backgroundColor = .secondarySystemGroupedBackground
        
        missionTypeIconBackgroundView.layer.cornerRadius = (missionTypeIconBackgroundView?.frame.width)!/(cornerRadiusConstant/5)
        missionTypeIconBackgroundView.alpha = 0.8
        
        missionTypeIconBackgroundView.isHidden = true
        missionTypeIconImageView.tintColor = .secondaryLabel
        missionTypeIconImageView.alpha = 0.8
        
        if let mission = launch.mission {
            missionTypeIconBackgroundView.isHidden = false
            missionTypeIconImageView.image = MissionController.missionTypeIconFor(mission: mission)
        }
        
    }
    
    private func setupBackground() {
        contentView.backgroundColor = .secondarySystemGroupedBackground
        contentView.layer.cornerCurve = .continuous
        contentView.layer.cornerRadius = contentView.frame.width/30
    }
        
    private func updateLabelText(launch: Launch) {
        if (launch.provider?.name?.count) ?? 25 > 24 {
            providerNameLabel.text = launch.provider?.abbreviation
        } else {
            providerNameLabel.text = launch.provider?.name
        }
        providerNameLabel.font = Fonts.cellTitle.uiFont
        rocketNameLabel.text = launch.rocket?.name
        rocketNameLabel.font = Fonts.cellSubtitle.uiFont
        rocketNameLabel.textColor = AppUI.accentColour
        launchDateLabel.text = statusController?.launchDate
        launchDateLabel.font = Fonts.cellDate.uiFont
        launchDateDescriptionLabel.text = statusController?.dateDescription
        launchDateDescriptionLabel.font = Fonts.cellBody.uiFont
    }
    
    //MARK: Countdown Methods
    func setupCountdown() {
        statusColorView?.layer.cornerCurve = .continuous
        statusColorView?.layer.cornerRadius = (statusColorView?.frame.width)!/(cornerRadiusConstant*2)
        for countdownBackground in countdownBackgroundViews {
            countdownBackground.layer.cornerCurve = .continuous
            countdownBackground.layer.cornerRadius = (countdownBackground.frame.width)/(cornerRadiusConstant/4)
        }
        tMinusPlusBackgroundView.layer.cornerRadius = tMinusPlusBackgroundView.frame.width/(cornerRadiusConstant/8)
        for title in countdownTitleLabels {
            title.font = Fonts.cellSmall.uiFont
        }
        for label in countdownLabels! {
            label.font = Fonts.cellCountdown.uiFont
        }
    }
            
    func updateCountdown(launch: Launch, status: StatusController) {
//        if launch.isPendingDate || launch.isPendingTime {
//            self.countdownBackgroundView.backgroundColor = Colours.moonSurfaceGrey.ui
//        }
        statusColorView.backgroundColor = status.color
        daysLabel.text = status.countdownComponents.days
        hoursLabel.text = status.countdownComponents.hours
        minutesLabel.text = status.countdownComponents.minutes
        secondsLabel.text = status.countdownComponents.seconds
        tMinusPlusLabel.text = status.countdownComponents.t
    }
    
}
