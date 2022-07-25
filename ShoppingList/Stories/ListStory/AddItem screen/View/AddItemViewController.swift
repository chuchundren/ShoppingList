//
//  AddItemViewController.swift
//  ShoppingList
//
//  Created by Dasha Palshau on 10.05.2022.
//

import UIKit

class AddItemViewController: UIViewController {

	var presenter: AddItemScreenOutput?

	// MARK: - Private

	// MARK: UI

	private let textField: UITextField = {
		let textField = UITextField()
		textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter your item's title"
		return textField
	}()

	private let stepper: Stepper = {
		let stepper = Stepper()
		stepper.translatesAutoresizingMaskIntoConstraints = false
		stepper.minimalValue = 1
		stepper.value = 1
		return stepper
	}()

	private let cancelButton: UIButton = {
		let button = UIButton()
		button.setTitle("Cancel", for: .normal)
		button.setTitleColor(.systemBlue, for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()

	init() {
		super.init(nibName: nil, bundle: nil)
		transitioningDelegate = self
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: Override

    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .white

		view.addSubviews(textField, stepper, cancelButton)
		NSLayoutConstraint.activate([
			textField.top(equalTo: view.topAnchor, constant: 16),
			textField.leading(equalTo: view.leadingAnchor, constant: 16),
			textField.trailing(equalTo: stepper.leadingAnchor, constant: -16),
			textField.heightAnchor.constraint(equalToConstant: 32),

			stepper.heightAnchor.constraint(equalTo: textField.heightAnchor),
			stepper.trailing(equalTo: view.trailingAnchor, constant: -16),
			stepper.top(equalTo: textField.topAnchor),

			cancelButton.trailing(equalTo: stepper.trailingAnchor),
			cancelButton.top(equalTo: stepper.bottomAnchor, constant: 8)
		])
        
        textField.addTarget(self, action: #selector(addNewItem), for: .primaryActionTriggered)
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
    }

	override func viewDidAppear(_ animated: Bool) {
		textField.becomeFirstResponder()
	}

	// MARK: - Private functions

	// MARK: @objc

	@objc private func cancel() {
		dismiss(animated: true)
	}

	@objc private func addNewItem() {
		defer {
			dismiss(animated: true, completion: nil)
		}

		guard let title = textField.text, !title.isEmpty else {
			return
		}
        
        presenter?.didAskToSaveNewItem(with: title, quantity: stepper.value)
	}

}

extension AddItemViewController: UIViewControllerTransitioningDelegate {
	func presentationController(forPresented presented: UIViewController,
								presenting: UIViewController?,
								source: UIViewController) -> UIPresentationController? {
		SheetController(presentedViewController: presented, presenting: presenting ?? source)
	}
	
	func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		SheetTransitionAnimation()
	}

	func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		SheetTransitionAnimation()
	}

}
