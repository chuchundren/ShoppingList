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
    
    func configure(with model: ViewModel) {
        titleLabel.attributedText = model.title
        descriptionLabel.text = model.subtitle
        quantityLabel.text = model.quantity
        configureButton(id: model.id, checked: model.isChecked, onCheck: model.check)
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
        let upperStack = UIStackView(arrangedSubviews: [titleLabel, quantityLabel, UIView()])
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
    
    func configureButton(id: String, checked: Bool?, onCheck: ((String) -> Void)?) {
        guard let isChecked = checked, let check = onCheck else {
            checkButton.isHidden = true
            return
        }
        
        setCheckButtonImage(for: isChecked)
        checkButton.addAction(for: .touchUpInside, uniqueEvent: true) { _ in
            check(id)
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
            label.numberOfLines = 0
        case .description:
            label.font = .systemFont(ofSize: 16)
            label.textColor = .textGray
            label.numberOfLines = 0
        case .quantity:
            label.font = .systemFont(ofSize: 17)
            label.textColor = .textGray
        }
        
        return label
    }
    
}

extension ListCell {
    
    enum LabelPurpose {
        case title, description, quantity
    }
    
}

// MARK: - ViewModel

extension ListCell {
    
    struct ViewModel {
        let title: NSAttributedString
        let subtitle: String?
        let id: String
        let select: () -> Void
        let check: ((String) -> Void)?
        let quantity: String?
        var isChecked: Bool?
        
        init(list: ShoppingList, select: @escaping () -> Void) {
            title = list.title.attributed()
            
            let shouldBeSingular = list.items.count % 10 == 1
            subtitle = "\(list.items.count) \(shouldBeSingular ? "item" : "items")"
            id = list.id
            check = nil
            quantity = nil
            isChecked = nil
            self.select = select
        }
        
        init(item: Item, check: ((String) -> Void)?, select: @escaping () -> Void) {
            title = item.isChecked ? item.title.strikeThrough() : item.title.attributed()
            subtitle = item.itemDescription
            id = item.id
            quantity = "X\(item.quantity)"
            isChecked = item.isChecked
            
            self.check = check
            self.select = select
        }
    }
    
}

private extension String {

	func strikeThrough() -> NSAttributedString {
        NSAttributedString(
			string: self,
			attributes: [.strikethroughStyle : NSUnderlineStyle.single.rawValue,
						 .foregroundColor: UIColor.textGray]
		)
	}
    
    func attributed() -> NSAttributedString {
        NSAttributedString(string: self)
    }

}
