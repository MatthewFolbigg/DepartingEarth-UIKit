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
    @IBOutlet var orbitLabel: UILabel!
        
    override func setupCell() {
        super.setupCell()
        self.tag = 3
        setupBackground()
        setFontToTitle(labels: [missionNameLabel])
        setFontToBody(labels: [missionTypeLabel, orbitLabel])
        
        missionNameLabel.text = launch?.mission?.name
        missionTypeLabel.text = launch?.mission?.type
        print(launch?.mission)
        orbitLabel.text = launch?.mission?.orbit?.name
    }
    
}
