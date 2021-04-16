//
//  LaunchDetailMissionCell.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 16/04/2021.
//

import Foundation
import UIKit

class LaunchDetailMissionCell: UICollectionViewCell {
    
    @IBOutlet var missionNameLabel: UILabel!
    @IBOutlet var missionTypeLabel: UILabel!
    @IBOutlet var orbitLabel: UILabel!

    var launch: Launch?
    var status: StatusController?
        
    func setupCell() {
        setupBackground()
        
        missionNameLabel.font = Fonts.customMonospacedDigit(15, .semibold).uiFont
        missionTypeLabel.font = Fonts.customMonospacedDigit(15, .light).uiFont
        orbitLabel.font = Fonts.customMonospacedDigit(15, .light).uiFont
        
        missionNameLabel.text = launch?.mission?.name
        missionTypeLabel.text = launch?.mission?.type
        orbitLabel.text = launch?.mission?.orbit?.name
    }
    
    private func setupBackground() {
        contentView.backgroundColor = .secondarySystemGroupedBackground
        contentView.layer.cornerCurve = .continuous
        contentView.layer.cornerRadius = contentView.frame.width/30
    }
    
}
