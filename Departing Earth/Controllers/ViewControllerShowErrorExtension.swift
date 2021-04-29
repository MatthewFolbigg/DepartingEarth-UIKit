//
//  ViewControllerShowErrorExtension.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 29/04/2021.
//

import Foundation
import UIKit

extension UIViewController {
    
    func displayError(title: String, message: String, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            alert.addAction(action)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
}
