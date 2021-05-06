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
    @IBOutlet var missionDescriptionTextView: UITextView!
    
    @IBOutlet var doneButton: UIButton!
    
    var mission: Mission!
    
    override func viewDidLoad() {
        setTextForLabels()
        setFontsForLabels()
        textBackgroundView.alpha = 0.95
        missionTitleLabel.textColor = AppUI.accentColour
        textBackgroundView.layer.shadowOpacity = 0.2
        textBackgroundView.layer.shadowRadius = 20
        textBackgroundView.layer.cornerRadius = textBackgroundView.frame.width/20
    }
    
    @IBAction func doneButtonDidTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setTextForLabels() {
        missionTitleLabel.text = mission.name
        missionDescriptionTextView.text = mission.objectives
    }
    
    func setFontsForLabels() {
        missionTitleLabel.font = Fonts.cellTitle.uiFont
        missionDescriptionTextView.font = Fonts.customMonospacedDigit(15, .light).uiFont
    }
    
}
