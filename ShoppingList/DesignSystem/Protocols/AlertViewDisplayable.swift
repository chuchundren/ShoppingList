//
//  AlertViewDisplayable.swift
//  ShoppingList
//
//  Created by Dasha Palshau on 14.02.2022.
//

import UIKit

protocol AlertViewDisplayable {
    func showAlert(title: String, message: String, actions: [UIAlertAction], style: UIAlertController.Style)
}

protocol AlertViewDisplayableTrait: UIViewController, AlertViewDisplayable {}

extension AlertViewDisplayableTrait {
    func showAlert(title: String?, message: String?, actions: [UIAlertAction], style: UIAlertController.Style = .alert) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        
        actions.forEach { alert.addAction($0) }
        
        present(alert, animated: true)
    }
}
