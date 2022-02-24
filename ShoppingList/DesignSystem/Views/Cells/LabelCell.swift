//
//  LabelCell.swift
//  ShoppingList
//
//  Created by Dasha Palshau on 03.02.2022.
//

import UIKit

class LabelCell: UICollectionViewCell {
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension LabelCell: ConfigurableView {
    
    func configure(with viewModel: ViewModel) {
        titleLabel.text = viewModel.title
        backgroundColor = .lightGray
    }
    
    func measureWidth(model: ViewModel, height: CGFloat) -> CGFloat {
        configure(with: model)
        
        return systemLayoutSizeFitting(
            CGSize(width: .zero, height: height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        .width
    }
    
}

// MARK: - Private methods

private extension LabelCell {
    
    func setupView() {
        addRoundedCorners(radius: frame.height / 2)
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
    }
    
    func setupLayout() {
        addSubviews(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
}

// MARK: - ViewModel

extension LabelCell {
    
    struct ViewModel {
        let title: String
        let color: UIColor
    }
}
