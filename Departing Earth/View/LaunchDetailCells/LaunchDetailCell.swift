//
//  LaunchDetailCell.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 17/04/2021.
//

import Foundation
import UIKit

class LaunchDetailCell: UICollectionViewCell {
    
    var launch: Launch?
    var status: StatusController?
    var cornerRadiusConstant: CGFloat = 30
        
    func setupCell() {
        setupBackground()
    }
    
    func setupBackground() {
        contentView.backgroundColor = .secondarySystemGroupedBackground
        contentView.layer.cornerCurve = .continuous
        contentView.layer.cornerRadius = contentView.frame.width/cornerRadiusConstant
    }
    
    func setFontToTitle(labels: [UILabel]) {
        for label in labels {
            label.font = Fonts.cellSubtitle.uiFont
            label.textColor = .label
        }
    }
    
    func setFontToBody(labels: [UILabel]) {
        for label in labels {
            label.font = Fonts.cellSubtitleTwo.uiFont
            label.textColor = .label
        }
    }
    
    func setRoundedCorners(view: UIView, modifier: CGFloat = 1) {
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = contentView.frame.width/cornerRadiusConstant/modifier
    }
    
    
}
