//
//  LaunchDetailTitleCell.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 21/04/2021.
//

import Foundation
import UIKit

class LaunchDetailTitleCell: LaunchDetailCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    
    override func setupCell() {
        super.setupCell()
        if let provider = launch?.provider{
            if (provider.name?.count) ?? 25 > 24 {
                titleLabel.text = provider.abbreviation
            } else {
                titleLabel.text = provider.name
            }
        }
        
        subtitleLabel.text = launch?.rocket?.name
        titleLabel.font = Fonts.navigationTitleLarge.uiFont
        subtitleLabel.font = Fonts.cellSubtitleTwo.uiFont
    }
    
}
