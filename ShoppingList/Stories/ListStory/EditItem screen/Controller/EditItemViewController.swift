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
    
    let editView = EditItemView()
    let deleteButton = makeButton()
    
    var presenter: EditItemScreenOutput?
    var labels: [ItemLabel] = [.healthy, .junk, .snack, .utilities, .other, .healthy, .healthy, .snack, .utilities, .utilities, .junk]

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupNavigationBar()
        
        presenter?.viewDidLoad()
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
                target: nil,
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
    
    // MARK: Layout
    
    func setupLayout() {
        view.addSubviews(editView,
                         deleteButton)
        
        NSLayoutConstraint.activate([
        editView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        editView.topAnchor.constraint(equalTo: view.topAnchor),
        editView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        
        deleteButton.heightAnchor.constraint(equalToConstant: 44),
        deleteButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
        deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        deleteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
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

