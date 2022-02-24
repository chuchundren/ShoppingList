//
//  CardCell.swift
//  ShoppingList
//
//  Created by Dasha Palshau on 30.01.2022.
//

import UIKit

final class CardCell: UICollectionViewCell {
    
    // MARK: - Private
    
    // MARK: UI
    
    private var embeddedView = UIView()
    
    // MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
}

// MARK: - ConfigurableView

extension CardCell: ConfigurableView {
    
    func configure(with viewModel: ViewModel) {
        embeddedView = viewModel.view
        setupLayout()
    }

}

// MARK: - Private methods

private extension CardCell {
    
    // MARK: Setup
    
    func setupView() {
        addRoundedCorners(radius: 12)
    }
    
    func setupLayout() {
        removeAllSubviews()
        
        addSubviews(embeddedView)
        embeddedView.pinToSuperview()
    }
    
}

// MARK: ViewModel

extension CardCell {
    
    struct ViewModel {
        let view: UIView
    }
    
}
