//
//  UITextView+Extension.swift
//  ShoppingList
//
//  Created by Dasha Palshau on 05.01.2022.
//

import UIKit

// MARK: - Placeholder

extension UITextView {
    
    public var placeholder: String? {
        get {
            placeholderLabel?.text
        }
        set {
            if let label = placeholderLabel {
                label.text = newValue
                label.sizeToFit()
            } else {
                addPlaceholder(newValue)
            }
        }
    }

}

// MARK: - Private methods

private extension UITextView {
    
    var placeholderLabel: UILabel? {
        viewWithTag(Constants.placeholderTag) as? UILabel
    }
    
    func addPlaceholder(_ placeholderText: String?) {
        let placeholder = UILabel()
        
        placeholder.text = placeholderText
        placeholder.tag = Constants.placeholderTag
        placeholder.translatesAutoresizingMaskIntoConstraints = false
        
        placeholder.numberOfLines = 0
        placeholder.font = font
        placeholder.textColor = .lightGray
        placeholder.sizeToFit()
        
        placeholder.isHidden = !text.isEmpty
        
        addSubview(placeholder)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textDidChange),
            name: UITextView.textDidChangeNotification,
            object: nil
        )
        
        layoutPlaceholder()
    }
    
    func layoutPlaceholder() {
        if let placeholder = placeholderLabel {
            let x = textContainerInset.left + textContainer.lineFragmentPadding
            let y = textContainerInset.top
            let height = placeholder.frame.height
            
            NSLayoutConstraint.activate([
                placeholder.topAnchor.constraint(equalTo: topAnchor, constant: y),
                placeholder.leadingAnchor.constraint(equalTo: leadingAnchor, constant: x),
                placeholder.centerXAnchor.constraint(equalTo: centerXAnchor),
                placeholder.widthAnchor.constraint(equalTo: widthAnchor, constant: -(x * 2)),
                placeholder.heightAnchor.constraint(equalToConstant: height)
            ])
        
        }
    }
    
    @objc func textDidChange() {
        placeholderLabel?.isHidden = !text.isEmpty
    }
}

// MARK: - Constants

private extension UITextView {
    
    enum Constants {
        static let placeholderTag = 1000
    }
    
}
