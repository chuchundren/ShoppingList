//
//  ItemCollectionViewCell.swift
//  ShoppingList
//
//  Created by Dasha Palshau on 21.09.2021.
//

import UIKit

final class ListCell: UICollectionViewCell {
    
    // MARK: - Private
    
    // MARK: UI
    
    private let checkButton = UIButton()
    private let titleLabel = makeLabel(for: .title)
    private let descriptionLabel = makeLabel(for: .description)
    private let quantityLabel = makeLabel(for: .quantity)
    private let priceLabel = makeLabel(for: .price)
    
    // MARK: - Initilizers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public functions
    
    func configure(with viewModel: ViewModel) {
		switch viewModel.type {
		case .list:
			priceLabel.isHidden = true
			quantityLabel.isHidden = true
			titleLabel.text = viewModel.title
		case let .itemToBuy(quantity, isChecked, _):
			strikeThroughItemTitle(isChecked, text: viewModel.title)
			quantityLabel.text = "X\(quantity)"
			priceLabel.isHidden = true
		case let .recentlyBought(price, quantity):
			quantityLabel.text = "X\(quantity)"
			priceLabel.text = price
			titleLabel.text = viewModel.title
		}

		descriptionLabel.isHidden = viewModel.description == nil
        descriptionLabel.text = viewModel.description
        descriptionLabel.numberOfLines = 0
        
		configureButton(with: viewModel.type)
    }
    
    func measureHeight(model: ViewModel, width: CGFloat) -> CGFloat {
        configure(with: model)
        
        return systemLayoutSizeFitting(
            CGSize(width: width, height: .zero),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        .height
    }
    
}

// MARK: - Private functions

private extension ListCell {
    
    // MARK: Setup
    
    func setupView() {
        backgroundColor = .secondaryBg
        layer.cornerRadius = 14
    }
    
    func setupLayout() {
        let stack = makeMainStack()
        addSubviews(stack)
        
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    func makeMainStack() -> UIStackView {
        let upperStack = UIStackView(arrangedSubviews: [titleLabel, quantityLabel, UIView(), priceLabel])
        upperStack.axis = .horizontal
        upperStack.distribution = .fill
        upperStack.alignment = .center
        upperStack.spacing = 8
        
        let verticalStack = UIStackView(arrangedSubviews: [upperStack, descriptionLabel])
        verticalStack.axis = .vertical
        verticalStack.distribution = .fill
        verticalStack.spacing = 0
        
        let stack = UIStackView(arrangedSubviews: [checkButton, verticalStack])
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 12
        
        return stack
    }
    
    // MARK: - Configuration

    // MARK: Button
    
    func configureButton(with type: ViewModel.ListCellType) {
        guard case let .itemToBuy(_, isChecked, onCheck) = type else {
            checkButton.isHidden = true
            return
        }
        
        setCheckButtonImage(for: isChecked)
        
		checkButton.addAction(for: .touchUpInside, uniqueEvent: true) { _ in
            onCheck()
        }
    }

	func strikeThroughItemTitle(_ isStrikeThrough: Bool, text: String) {
		if isStrikeThrough {
			titleLabel.attributedText = text.strikeThrough()
		} else {
			titleLabel.attributedText = nil
			titleLabel.text = text
		}
	}

    func setCheckButtonImage(for isChecked: Bool) {
        let image = isChecked ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "circle")
        checkButton.setImage(image, for: .normal)
        
        checkButton.setPreferredSymbolConfiguration(
            UIImage.SymbolConfiguration(pointSize: 24),
            forImageIn: .normal
        )
        
        checkButton.tintColor = .systemGreen
    }
    
    static func makeLabel(for purpose: LabelPurpose) -> UILabel {
        let label = UILabel()
        
        switch purpose {
        case .title:
            label.font = .systemFont(ofSize: 18)
            label.textColor = .textMain
        case .description:
            label.font = .systemFont(ofSize: 16)
            label.textColor = .textGray
        case .quantity:
            label.font = .systemFont(ofSize: 17)
            label.textColor = .textGray
        case .price:
            label.font = .systemFont(ofSize: 20)
            label.textColor = .textMain
        }
        
        return label
    }
    
}

extension ListCell {
    
    enum LabelPurpose {
        case title, description, quantity, price
    }
    
}

// MARK: - ViewModel

extension ListCell {
    
    struct ViewModel {
        
        var title: String
        var description: String?
        var type: ListCellType
        
        init(itemTitle: String, description: String?, type: ListCellType) {
            self.title = itemTitle
            self.description = description
            self.type = type
        }
        
        init(listTitle: String, description: String?) {
            self.title = listTitle
            self.description = description
            self.type = .list
        }
        
    }
    
}

extension ListCell.ViewModel {
    
    enum ListCellType {
        case list
        case itemToBuy(quantity: Int,
                      isChecked: Bool = false,
                      onCheck: (() -> Void))
        case recentlyBought(price: String, quantity: Int)
    }

}

private extension String {

	func strikeThrough() -> NSAttributedString {
		return NSAttributedString(
			string: self,
			attributes: [.strikethroughStyle : NSUnderlineStyle.single.rawValue,
						 .foregroundColor: UIColor.textGray]
		)
	}

}
