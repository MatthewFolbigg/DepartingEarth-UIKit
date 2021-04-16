//
//  LaunchDetailCountdownCell.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 16/04/2021.
//

import Foundation
import UIKit

class LaunchDetailCountdownCell: UICollectionViewCell {
    
    @IBOutlet var tLabel: UILabel!
    @IBOutlet var daysLabel: UILabel!
    @IBOutlet var hoursLabel: UILabel!
    @IBOutlet var minutesLabel: UILabel!
    @IBOutlet var secondsLabel: UILabel!
    
    @IBOutlet var tBackgroundView: UIView!
    @IBOutlet var daysBackgroundView: UIView!
    @IBOutlet var hoursBackgroundView: UIView!
    @IBOutlet var minutesBackgroundView: UIView!
    @IBOutlet var secondsBackgroundView: UIView!
        
    @IBOutlet var dayTitleLabel: UILabel!
    @IBOutlet var hourTitleLabel: UILabel!
    @IBOutlet var minuteTitleLabel: UILabel!
    @IBOutlet var secondTitleLabel: UILabel!
    
    var launch: Launch?
    var status: StatusController?
    var cornerRadiusConstant: CGFloat = 30
    
    func setupCell() {
        setupBackground()
        setupCountdowUI()
    }
    
    private func setupCountdowUI() {
        let countdownBackgrounds = [ daysBackgroundView, hoursBackgroundView, minutesBackgroundView, secondsBackgroundView, tBackgroundView ]
        let countdownLabels = [ daysLabel, hoursLabel, minutesLabel, secondsLabel, tLabel ]
        let countdownTitleLabels = [ dayTitleLabel, hourTitleLabel, minuteTitleLabel, secondTitleLabel ]
        
        for countdownBackground in countdownBackgrounds {
            countdownBackground?.layer.cornerCurve = .continuous
            countdownBackground?.layer.cornerRadius = (countdownBackground?.frame.width)!/(cornerRadiusConstant/4)
        }
        
        tBackgroundView.layer.cornerRadius = tBackgroundView.frame.width/(cornerRadiusConstant/8)
        for title in countdownTitleLabels {
            title?.font = Fonts.detailSmall.uiFont
        }
        for label in countdownLabels {
            label!.font = Fonts.detailCountdown.uiFont
        }
    }
    
    func updateCountdown(launch: Launch, status: StatusController) {
        if launch.isPendingDate || launch.isPendingTime {
            //self.countdownBackgroundView.backgroundColor = Colours.moonSurfaceGrey.ui
        }
        daysLabel.text = status.countdownComponents.days
        hoursLabel.text = status.countdownComponents.hours
        minutesLabel.text = status.countdownComponents.minutes
        secondsLabel.text = status.countdownComponents.seconds
        tLabel.text = status.countdownComponents.t
        //statusColorView.backgroundColor = status.color
    }
    
    private func setupBackground() {
        contentView.backgroundColor = .secondarySystemGroupedBackground
        contentView.layer.cornerCurve = .continuous
        contentView.layer.cornerRadius = contentView.frame.width/30
    }
}
