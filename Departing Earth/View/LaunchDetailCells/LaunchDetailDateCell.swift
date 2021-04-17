//
//  LaunchDetailDateCell.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 15/04/2021.
//

import Foundation
import UIKit

class LaunchDetailDateCell: LaunchDetailCell {
    
    @IBOutlet var dateStatusLabel: UILabel!
    @IBOutlet var statusIndicatorView: UIView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var dateImageView: UIImageView!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var timeImageView: UIImageView!
  
    override func setupCell() {
        super.setupCell()
        self.tag = 2
        setRoundedCorners(view: statusIndicatorView, modifier: 4)
        setFontToTitle(labels: [dateStatusLabel])
        setFontToBody(labels: [dateLabel, timeLabel])
        
        guard let status = status else { return }
        
        statusIndicatorView.backgroundColor = status.color
        dateImageView.tintColor = .secondaryLabel
        timeImageView.tintColor = .secondaryLabel
        
        dateStatusLabel.text = status.launchDescription
        dateLabel.text = status.launchDate
        timeLabel.text = status.launchTime
    }
    
}
