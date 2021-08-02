//
//  LaunchDetailCountdownCell.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 16/04/2021.
//

import Foundation
import UIKit

class LaunchDetailCountdownCell: LaunchDetailCell {
    
    @IBOutlet var countdownLabels: [UILabel]!
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
    @IBOutlet var statusColourView: UIView!
    @IBOutlet var countdownTitleLabels: [UILabel]!

    
    var countdownBackgrounds: [UIView]?
     
    //MARK:-
    override func setupCell() {
        super.setupCell()
        self.tag = 1
        setupBackground()
        setupCountdowUI()
    }
    
    private func setupCountdowUI() {
        let countdownBackgrounds = [ daysBackgroundView, hoursBackgroundView, minutesBackgroundView, secondsBackgroundView ]
        for countdownBackground in countdownBackgrounds {
            setRoundedCorners(view: countdownBackground!, modifier: 2)
        }
        
        setRoundedCorners(view: tBackgroundView, modifier: 2)
        setRoundedCorners(view: statusColourView, modifier: 2)
        
        for title in countdownTitleLabels {
            title.font = Fonts.detailSmall.uiFont
        }
        for label in countdownLabels {
            label.font = Fonts.detailCountdown.uiFont
        }
    }
    
    func updateCountdown(launch: Launch, status: StatusController) {
//        if launch.isPendingDate || launch.isPendingTime {
//            self.countdownBackgroundView.backgroundColor = Colours.moonSurfaceGrey.ui
//        }
        daysLabel.text = status.countdownComponents.days
        hoursLabel.text = status.countdownComponents.hours
        minutesLabel.text = status.countdownComponents.minutes
        secondsLabel.text = status.countdownComponents.seconds
        tLabel.text = status.countdownComponents.t
        statusColourView.backgroundColor = status.color
    }
    
}
