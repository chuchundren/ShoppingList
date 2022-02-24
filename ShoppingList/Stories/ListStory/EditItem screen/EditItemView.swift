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
    
    let titleTextView = makeTextView(for: .title)
    let descriptionTextView = makeTextView(for: .description)
    let stepper = makeStepper()
    let quantityLabel = makeLabel(for: .quantity)
    let priceLabel = makeLabel(for: .price)
    let priceForOneTextView = makeTextView(for: .priceForOne)
    let priceInTotalTextView = makeTextView(for: .priceInTotal)
    
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
        descriptionTextView.text = item.description
        
        titleTextView.placeholder = nil
        
        if let descrip = item.description, !descrip.isEmpty || item.description.isNil {
            descriptionTextView.placeholder = nil
        }
        
        stepper.value = Double(item.quantity)
        quantityLabel.text = "Quantity: \(item.quantity)"
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
            label: nil,
            quantity: Int(stepper.value)
        )
        
        return item
    }
    
}

// MARK: - Private functions

private extension EditItemView {
    
    // MARK: Setup
    
    func setupView() {
        backgroundColor = .white
        addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(UIView.endEditing(_:))
            )
        )
    }
    
    func setupSubviews() {
        stepper.addAction(for: .valueChanged) { [weak self] _ in
            guard let self = self else { return }
            
            self.quantityLabel.text = "Quantity: \(Int(self.stepper.value))"
            self.configureTotalPrice()
        }
        
        titleTextView.delegate = self
        priceForOneTextView.delegate = self
        priceInTotalTextView.delegate = self
    }
    
    // MARK: Layout
    
    func setupLayout() {
        let priceStack = makePriceStack()
        addSubviews(titleTextView,
                    descriptionTextView,
                    quantityLabel,
                    stepper,
                    priceStack)
        
        NSLayoutConstraint.activate([
            titleTextView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            titleTextView.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleTextView.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleTextView.heightAnchor.constraint(equalToConstant: 40),
            
            descriptionTextView.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: 8),
            descriptionTextView.leadingAnchor.constraint(equalTo: titleTextView.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: titleTextView.trailingAnchor),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 100),
            
            quantityLabel.centerYAnchor.constraint(equalTo: stepper.centerYAnchor),
            quantityLabel.leadingAnchor.constraint(equalTo: titleTextView.leadingAnchor),
            quantityLabel.trailingAnchor.constraint(equalTo: stepper.leadingAnchor),
            
            stepper.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 16),
            stepper.leadingAnchor.constraint(equalTo: quantityLabel.trailingAnchor),
            stepper.trailingAnchor.constraint(equalTo: titleTextView.trailingAnchor),
            
            priceStack.topAnchor.constraint(equalTo: stepper.bottomAnchor, constant: 16),
            priceStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            priceStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
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
            let formattedPrice = NumberFormatter.currencyFormatter.string(from: NSNumber(value: price * stepper.value))
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
        textView.backgroundColor = .bg
        
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
                let formattedPrice = NumberFormatter.currencyFormatter.string(from: NSNumber(value: price / stepper.value))
                priceForOneTextView.text = formattedPrice
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == priceForOneTextView {
            if let text = priceForOneTextView.text, let price = Double(text) {
                let formattedPrice = NumberFormatter.currencyFormatter.string(from: NSNumber(value: price * stepper.value))
                priceForOneTextView.text = formattedPrice
            }
        } else if textView == priceInTotalTextView {
            if let text = priceInTotalTextView.text, let price = Double(text) {
                let formattedPrice = NumberFormatter.currencyFormatter.string(from: NSNumber(value: price / stepper.value))
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
    
    enum LabelPurpose {
        case quantity, price
    }
    
}
