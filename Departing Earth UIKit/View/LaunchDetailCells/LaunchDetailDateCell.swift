//
//  LaunchDetailDateCell.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 15/04/2021.
//

import Foundation
import UIKit

protocol CalendarCellDelegate {
    func didTapAddToCalButton(launch: Launch)
}

class LaunchDetailDateCell: LaunchDetailCell {
    
    @IBOutlet var dateStatusLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var dateImageView: UIImageView!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var timeImageView: UIImageView!
    
    @IBOutlet var addToCalButton: UIButton!
    var delegate: CalendarCellDelegate?
  
    override func setupCell() {
        super.setupCell()
        self.tag = 2
        setFontToTitle(labels: [dateStatusLabel])
        setFontToBody(labels: [dateLabel, timeLabel])
        
        dateImageView.tintColor = .secondaryLabel
        timeImageView.tintColor = .secondaryLabel
        addToCalButton.tintColor = Colours.spaceSuitOrange.ui
        
        guard let status = status else { return }
        dateStatusLabel.text = status.launchDescription
        dateLabel.text = status.launchDate
        timeLabel.text = status.launchTime
    }
    
    @IBAction func addToCalButtonDidPressed() {
        guard let launch = launch else { return }
        if let delegate = self.delegate {
            delegate.didTapAddToCalButton(launch: launch)
        }
    }
    
    
    
}
