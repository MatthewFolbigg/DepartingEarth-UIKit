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
    @IBOutlet var daysTitleLabel: UILabel!
    @IBOutlet var hoursTitleLabel: UILabel!
    @IBOutlet var minutesTitleLabel: UILabel!
    @IBOutlet var secondsTitleLabel: UILabel!
    @IBOutlet var daysBackgroundView: UIView!
    @IBOutlet var hoursBackgroundView: UIView!
    @IBOutlet var minutesBackgroundView: UIView!
    @IBOutlet var secondsBackgroundView: UIView!
    @IBOutlet var statusColorView: UIView!
    @IBOutlet var tMinusPlusLabel: UILabel!
    @IBOutlet var tMinusPlusBackgroundView: UIView!
 
    //MARK: Other IBOutlets
    @IBOutlet var rocketNameLabel: UILabel!
    @IBOutlet var providerNameLabel: UILabel!
    @IBOutlet var launchDateLabel: UILabel!
    @IBOutlet var launchDateDescriptionLabel: UILabel!
    
    var launch: Launch?
    var statusController: StatusController?
    var cornerRadiusConstant: CGFloat = 30
    var countdownLabels: [UILabel]?
    var countdownBackgrounds: [UIView]?
    
    override func prepareForReuse() {
    }
    
    func setupCell() {
        guard let launch = launch else { return }
        guard let statusController = statusController else { return }
        countdownLabels = [ daysLabel, hoursLabel, minutesLabel, secondsLabel, tMinusPlusLabel ]
        countdownBackgrounds = [ daysBackgroundView, hoursBackgroundView, minutesBackgroundView, secondsBackgroundView, tMinusPlusBackgroundView ]
        setupBackground()
        setupCountdown()
        updateLabelText(launch: launch)
        updateCountdown(launch: launch, status: statusController)
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
        rocketNameLabel.textColor = Colours.spaceSuitOrange.ui
        launchDateLabel.text = statusController?.launchDate
        launchDateLabel.font = Fonts.cellDate.uiFont
        launchDateDescriptionLabel.text = statusController?.dateDescription
        launchDateDescriptionLabel.font = Fonts.cellBody.uiFont
    }
    
    //MARK: Countdown Methods
    func setupCountdown() {
        let countdownBackgrounds = [ daysBackgroundView, hoursBackgroundView, minutesBackgroundView, secondsBackgroundView, tMinusPlusBackgroundView ]
        let countdownTitleLabels = [ daysTitleLabel, hoursTitleLabel, minutesTitleLabel, secondsTitleLabel ]
        statusColorView?.layer.cornerCurve = .continuous
        statusColorView?.layer.cornerRadius = (statusColorView?.frame.width)!/(cornerRadiusConstant*2)
        for countdownBackground in countdownBackgrounds {
            countdownBackground?.layer.cornerCurve = .continuous
            countdownBackground?.layer.cornerRadius = (countdownBackground?.frame.width)!/(cornerRadiusConstant/4)
        }
        tMinusPlusBackgroundView.layer.cornerRadius = tMinusPlusBackgroundView.frame.width/(cornerRadiusConstant/8)
        for title in countdownTitleLabels {
            title?.font = Fonts.cellSmall.uiFont
        }
        for label in countdownLabels! {
            label.font = Fonts.cellCountdown.uiFont
        }
    }
            
    func updateCountdown(launch: Launch, status: StatusController) {
        if launch.isPendingDate || launch.isPendingTime {
            //self.countdownBackgroundView.backgroundColor = Colours.moonSurfaceGrey.ui
        }
        statusColorView.backgroundColor = status.color
        daysLabel.text = status.countdownComponents.days
        hoursLabel.text = status.countdownComponents.hours
        minutesLabel.text = status.countdownComponents.minutes
        secondsLabel.text = status.countdownComponents.seconds
        tMinusPlusLabel.text = status.countdownComponents.t
    
        if daysLabel.text == "00" { daysLabel.textColor = .secondaryLabel }
        if daysLabel.text == "00" && hoursLabel.text == "00" { hoursLabel.textColor = .secondaryLabel }
        if daysLabel.text == "00" && hoursLabel.text == "00" && minutesLabel.text == "00" && minutesLabel.text == "00" {
            for label in countdownLabels ?? [] { label.textColor = Colours.cosmonautSuitGreen.ui }
        }
        for label in countdownLabels ?? [] {
            if label.text == "--" {
                label.textColor = .tertiaryLabel
                tMinusPlusLabel.textColor = .tertiaryLabel
            }
        }
        if tMinusPlusLabel.text == "+" {
            for background in countdownBackgrounds ?? [] {
                background.backgroundColor = status.color
            }
        }
        
    }
    
}
