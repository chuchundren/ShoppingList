//
//  EditItemViewController.swift
//  ShoppingList
//
//  Created by Dasha Palshau on 19.12.2021.
//

import UIKit

protocol EditItemScreen: AnyObject {
    func configureView(with item: Item)
}

class EditItemViewController: UIViewController {
    
    // MARK: - Private
    
    // MARK: UI
    
    private let editView = EditItemView()
    private let deleteButton = makeButton()

	private var bottomConstraint: NSLayoutConstraint!
	private var keyboardBottomConstraint: NSLayoutConstraint!

    
    var presenter: EditItemScreenOutput?
    var labels: [ItemLabel] = [.healthy, .junk, .snack, .utilities, .other, .healthy, .healthy, .snack, .utilities, .utilities, .junk]

    override func viewDidLoad() {
        super.viewDidLoad()

		setupView()
		setupNavigationBar()

		presenter?.viewDidLoad()

		NotificationCenter.default.addObserver(
			self,
			selector: #selector(adjustForKeyboard(notification:)),
			name: UIResponder.keyboardWillShowNotification,
			object: nil
		)

		NotificationCenter.default.addObserver(
			self,
			selector: #selector(adjustForKeyboard(notification:)),
			name: UIResponder.keyboardWillHideNotification,
			object: nil
		)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

        configureGradient(in: title)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        setupLayout()
    }

}

// MARK: - AddItemViewControllerProtocol

extension EditItemViewController: EditItemScreen {
    
    func configureView(with item: Item) {
        editView.configureView(with: item)
    }
    
}

// MARK: - GradientNavigationBarTitleTrait

extension EditItemViewController: GradientNavigationBarTitleTrait {}

// MARK: - Private functions

private extension EditItemViewController {
    
    // MARK: Setup
    
    func setupView() {
        view.backgroundColor = UIColor(
			anyModeColor: .secondaryBg,
			darkModeColor: .bg)

        view.addGestureRecognizer(
            UITapGestureRecognizer(
                target: view,
                action: #selector(UIView.endEditing(_:))
            )
        )
        
        deleteButton.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
    }
    
    func setupNavigationBar() {
        title = "Edit item"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDoneButton))
    }
    
    // MARK: - Selectors
    
    @objc func didTapDoneButton() {
        if let item = editView.validateNewItem() {
            presenter?.didFinishEditing(item: item)
        }
    }
    
    @objc func didTapDeleteButton() {
        presenter?.didTapDeleteButton()
    }

	@objc func endEditing() {
		resignFirstResponder()
	}
    
    // MARK: Layout
    
    func setupLayout() {
        view.addSubviews(editView,
                         deleteButton)

		bottomConstraint = deleteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Constants.bottomConstraintConstant)
        
        NSLayoutConstraint.activate([
        editView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        editView.topAnchor.constraint(equalTo: view.topAnchor),
        editView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        
        deleteButton.heightAnchor.constraint(equalToConstant: 44),
        deleteButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
        deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        bottomConstraint
        ])
    }

	// MARK: @objc

	@objc func keyboardWillShow(with notification: Notification) {
		guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
			return
		}

		let keyboardHeight = keyboardValue.cgRectValue.height

		keyboardBottomConstraint = deleteButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -keyboardHeight + Constants.bottomConstraintConstant)

		bottomConstraint.isActive = false
		keyboardBottomConstraint.isActive = true

		UIView.animate(withDuration: 0.3) {
			self.view.layoutIfNeeded()
		}
	}

	@objc func keyboardWillHide(with notification: Notification) {
		keyboardBottomConstraint.isActive = false
		bottomConstraint.isActive = true

		UIView.animate(withDuration: 0.3) {
			self.view.layoutIfNeeded()

		}

	}

	@objc func adjustForKeyboard(notification: Notification) {
		guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
			return
		}

		if notification.name == UIResponder.keyboardWillShowNotification {
			let keyboardHeight = keyboardValue.cgRectValue.height 
			keyboardBottomConstraint = deleteButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -keyboardHeight + Constants.bottomConstraintConstant)

			bottomConstraint.isActive = false
			keyboardBottomConstraint.isActive = true
		} else {
			keyboardBottomConstraint.isActive = false
			bottomConstraint.isActive = true
		}

		UIView.animate(withDuration: 0.3) {
			self.view.layoutIfNeeded()
		}
	}

}

// MARK: - View builders

private extension EditItemViewController {
    
    static func makeButton() -> UIButton {
        let btn = UIButton()
        btn.backgroundColor = .bg
        btn.layer.cornerRadius = 8
        btn.setTitleColor(.red, for: .normal)
        btn.setTitle("Delete item", for: .normal)
        
        return btn
    }
    
}

private extension EditItemViewController {

	enum Constants {
		static let bottomConstraintConstant: CGFloat = -16
	}

}
