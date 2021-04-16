//
//  LaunchDetailDateCell.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 15/04/2021.
//

import Foundation
import UIKit

class LaunchDetailDateCell: UICollectionViewCell {
    
    @IBOutlet var dateStatusLabel: UILabel!
    @IBOutlet var statusIndicatorImageView: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var dateImageView: UIImageView!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var timeImageView: UIImageView!
    
    @IBOutlet var addToCalendarButton: UIButton!
    
    var launch: Launch?
    var status: StatusController?
        
    func setupCell() {
        setupBackground()
        
        dateStatusLabel.font = Fonts.customMonospacedDigit(15, .semibold).uiFont
        dateLabel.font = Fonts.customMonospacedDigit(15, .light).uiFont
        timeLabel.font = Fonts.customMonospacedDigit(15, .light).uiFont
        
        guard let status = status else { return }
        
        statusIndicatorImageView.tintColor = status.color
        dateImageView.tintColor = .secondaryLabel
        timeImageView.tintColor = .secondaryLabel
        addToCalendarButton.tintColor = Colours.spaceSuitOrange.ui
        
        dateStatusLabel.text = status.launchDescription
        dateLabel.text = status.launchDate
        timeLabel.text = status.launchTime
        
        addToCalendarButton.isEnabled = true
    }
    
    private func setupBackground() {
        contentView.backgroundColor = .secondarySystemGroupedBackground
        contentView.layer.cornerCurve = .continuous
        contentView.layer.cornerRadius = contentView.frame.width/30
    }
    
}
