//
//  GenerateAlert.swift
//  My Book shelf
//
//  Created by Muteb Alolayan on 12/08/2021.
//

import Foundation
import UIKit

extension UIViewController {
    
    func generateAlert(title: String, message: String, actionTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler:  {_ in return }))
        present(alert, animated: true, completion: nil)
    }
}

