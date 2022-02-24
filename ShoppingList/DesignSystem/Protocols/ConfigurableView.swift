//
//  ConfigurableView.swift
//  ShoppingList
//
//  Created by Dasha Palshau on 30.01.2022.
//

import UIKit

protocol ConfigurableView: UIView {
    associatedtype ViewModel
    
    func configure(with viewModel: ViewModel)
}
