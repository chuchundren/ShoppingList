//
//  EditItemView.swift
//  ShoppingList
//
//  Created by Dasha Palshau on 09.02.2022.
//

import UIKit

class EditItemView: UIView {

    // MARK: - Private
    
    // MARK: UI
    
    private let titleTextView = makeTextView(for: .title)
	private let descriptionTextView = makeTextView(for: .description)

	private let stepper: Stepper = {
		let stepper = Stepper()
		stepper.minimalValue = 1
		return stepper
	}()

	private let priceLabel = makeLabel(for: .price)
	private let priceForOneTextView = makeTextView(for: .priceForOne)
	private let priceInTotalTextView = makeTextView(for: .priceInTotal)
    
    init() {
        super.init(frame: .zero)
        setupView()
        setupSubviews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView(with item: Item) {
        titleTextView.text = item.title
        descriptionTextView.text = item.itemDescription
        
        titleTextView.placeholder = nil
        
		if let descrip = item.itemDescription, !descrip.isEmpty || item.itemDescription.isNil {
            descriptionTextView.placeholder = nil
        }
        
        stepper.value = item.quantity
    }
    
    func validateNewItem() -> Item? {
        guard let title = titleTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                !title.isEmpty
        else {
            configureTitleTextField(withError: true)
            titleTextView.shake()
            return nil
        }
        
        let descriptionText = descriptionTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let description = descriptionText.isEmpty ? nil : descriptionText
        
        let item = Item(
            title: title,
			description: description,
            quantity: stepper.value
        )
        
        return item
    }
    
}

// MARK: - Private functions

private extension EditItemView {
    
    // MARK: Setup
    
    func setupView() {
        backgroundColor = .clear
    }
    
    func setupSubviews() {
        titleTextView.delegate = self
        priceForOneTextView.delegate = self
        priceInTotalTextView.delegate = self
    }
    
    // MARK: Layout
    
    func setupLayout() {
        let priceStack = makePriceStack()
        addSubviews(titleTextView,
                    descriptionTextView,
                    stepper,
                    priceStack)
        
        NSLayoutConstraint.activate([
            titleTextView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            titleTextView.leadingAnchor.constraint(equalTo: leadingAnchor),
			titleTextView.trailingAnchor.constraint(equalTo: stepper.leadingAnchor, constant: -12),
            titleTextView.heightAnchor.constraint(equalToConstant: 40),

			stepper.centerYAnchor.constraint(equalTo: titleTextView.centerYAnchor),
			stepper.heightAnchor.constraint(equalTo: titleTextView.heightAnchor),
			stepper.trailingAnchor.constraint(equalTo: trailingAnchor),

            descriptionTextView.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: 8),
            descriptionTextView.leadingAnchor.constraint(equalTo: titleTextView.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: trailingAnchor),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 100),
            
			priceStack.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 16),
			priceStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            priceStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            priceStack.heightAnchor.constraint(equalToConstant: 40),
            priceStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func makePriceStack() -> UIStackView {
        let stack = UIStackView(arrangedSubviews: [
            priceLabel,
            priceForOneTextView,
            priceInTotalTextView
        ])
        
        NSLayoutConstraint.activate([
            priceForOneTextView.widthAnchor.constraint(equalToConstant: 120),
            priceForOneTextView.heightAnchor.constraint(equalToConstant: 36),
            priceInTotalTextView.widthAnchor.constraint(equalTo: priceForOneTextView.widthAnchor),
            priceInTotalTextView.heightAnchor.constraint(equalTo: priceForOneTextView.heightAnchor)
            
        ])
        
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 12

        return stack
    }
    
    func configureTitleTextField(withError: Bool) {
        if withError {
            titleTextView.layer.borderColor = UIColor.red.cgColor
            titleTextView.layer.borderWidth = 1
        } else {
            titleTextView.layer.borderColor = UIColor.clear.cgColor
            titleTextView.layer.borderWidth = 0
        }
    }
    
    func configureTotalPrice() {
        if let text = priceForOneTextView.text, let price = Double(text) {
            let formattedPrice = NumberFormatter.currencyFormatter.string(from: NSNumber(value: price * Double(stepper.value)))
            priceInTotalTextView.text = formattedPrice
        }
    }
    
}

// MARK: - View builders

private extension EditItemView {
    
    static func makeTextView(for purpose: TextFieldPurpose) -> UITextView {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 16)
        textView.layer.cornerRadius = 8
		textView.backgroundColor = Constants.viewBackgroundColor
        
        if purpose == .title {
            textView.placeholder = "Enter item's title"
        } else if purpose == .description {
            textView.placeholder = "Description"
        } else if purpose == .priceForOne {
            textView.placeholder = "For one item"
            textView.keyboardType = .decimalPad
        } else if purpose == .priceInTotal {
            textView.textAlignment = .right
            textView.placeholder = "Total"
            textView.keyboardType = .decimalPad
        }
        
        return textView
    }
    
    static func makeStepper() -> UIStepper {
        let stepper = UIStepper()
        stepper.minimumValue = 1
        
        return stepper
    }
    
    static func makeLabel(for purpose: LabelPurpose) -> UILabel {
        let label = UILabel()
        if purpose == .quantity {
            label.text = "Quantity: 1"
        } else if purpose == .price {
            label.text = "Price:"
        }
        
        return label
    }
    
}

// MARK: - UITextViewDelegate

extension EditItemView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if textView == titleTextView {
            if !titleTextView.text.isEmpty {
                configureTitleTextField(withError: false)
            }
        } else if textView == priceForOneTextView {
            configureTotalPrice()
        } else if textView == priceInTotalTextView {
            if let text = priceInTotalTextView.text, let price = Double(text) {
                let formattedPrice = NumberFormatter.currencyFormatter.string(from: NSNumber(value: price / Double(stepper.value)))
                priceForOneTextView.text = formattedPrice
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == priceForOneTextView {
            if let text = priceForOneTextView.text, let price = Double(text) {
                let formattedPrice = NumberFormatter.currencyFormatter.string(from: NSNumber(value: price * Double(stepper.value)))
                priceForOneTextView.text = formattedPrice
            }
        } else if textView == priceInTotalTextView {
            if let text = priceInTotalTextView.text, let price = Double(text) {
                let formattedPrice = NumberFormatter.currencyFormatter.string(from: NSNumber(value: price / Double(stepper.value)))
                priceInTotalTextView.text = formattedPrice
            }
        }
    }
    
}

// MARK: - TextFieldPurpose

private extension EditItemView {
    
    enum TextFieldPurpose {
        case title, description, priceForOne, priceInTotal
    }

}

// MARK: - LabelPurpose

private extension EditItemView {
    
    enum LabelPurpose {
        case quantity, price
    }
    
}

// MARK: - Constants

private extension EditItemView {

	enum Constants {
		static let viewBackgroundColor = UIColor(
			anyModeColor: .bg,
			darkModeColor: .secondaryBg
		)
	}

}
