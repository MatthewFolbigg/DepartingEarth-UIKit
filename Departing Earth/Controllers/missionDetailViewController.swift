//
//  missionDetailViewController.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 10/04/2021.
//

import Foundation
import UIKit

class MissionDetailViewController: UIViewController {
    
    @IBOutlet var textBackgroundView: UIView!
    @IBOutlet var missionTitleLabel: UILabel!
    @IBOutlet var missionTypeLabel: UILabel!
    @IBOutlet var missionDescriptionTextView: UITextView!
    
    var mission: Mission!
    
    override func viewDidLoad() {
        setTextForLabels()
        setFontsForLabels()
        textBackgroundView.layer.cornerRadius = textBackgroundView.frame.width/20
        
    }
    
    func setTextForLabels() {
        missionTitleLabel.text = mission.name
        missionTypeLabel.text = mission.type
        missionDescriptionTextView.text = mission.objectives
    }
    
    func setFontsForLabels() {
        missionTitleLabel.font = Fonts.customMonospaced(20, .semibold).uiFont
        missionTypeLabel.font = Fonts.customMonospaced(15, .regular).uiFont
        missionDescriptionTextView.font = Fonts.cellBody.uiFont
    }
    
}
