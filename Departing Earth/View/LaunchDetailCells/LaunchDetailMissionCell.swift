//
//  LaunchDetailMissionCell.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 16/04/2021.
//

import Foundation
import UIKit

class LaunchDetailMissionCell: LaunchDetailCell {
    
    @IBOutlet var missionNameLabel: UILabel!
    @IBOutlet var missionTypeLabel: UILabel!
    @IBOutlet var orbitImageView: UIImageView!
    @IBOutlet var missionTypeImageView: UIImageView!
    @IBOutlet var orbitLabel: UILabel!
    
    @IBOutlet var missionInfoImageView: UIImageView!
        
    override func setupCell() {
        super.setupCell()
        self.tag = 3
        if  launch?.mission?.objectives == nil {
            missionInfoImageView.isHidden = true
        }
        
        setupBackground()
        setFontToTitle(labels: [missionNameLabel])
        setFontToBody(labels: [missionTypeLabel, orbitLabel])
        
        missionNameLabel.text = launch?.mission?.name ?? "Mission Details Pending"
        missionTypeLabel.text = launch?.mission?.type ?? "Pending Type"
        orbitLabel.text = launch?.mission?.orbitName ?? "Pending Orbit"
        
        missionTypeImageView.tintColor = .secondaryLabel
        if let mission = launch?.mission {
            missionTypeImageView.image = MissionController.missionTypeIconFor(mission: mission)
        }
        orbitImageView.tintColor = .secondaryLabel
        missionInfoImageView.tintColor = Colours.spaceSuitOrange.ui
    }
}
