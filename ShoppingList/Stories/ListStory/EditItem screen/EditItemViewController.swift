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
    let labelsCollection = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    var presenter: EditItemScreenOutput?
    var labels: [ItemLabel] = [.healthy, .junk, .snack, .utilities, .other, .healthy, .healthy, .snack, .utilities, .utilities, .junk]

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupCollectionView()
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

// MARK: - UICollectionViewDataSource

extension EditItemViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        labels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LabelCell.identifier, for: indexPath) as? LabelCell else {
            return UICollectionViewCell()
        }
        
        let label = labels[indexPath.item]
        let viewModel = LabelCell.ViewModel(title: label.title, color: label.color)

        cell.configure(with: viewModel)
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension EditItemViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = labels[indexPath.item]
        let width = label.title.size(withAttributes: [.font : UIFont.systemFont(ofSize: 17, weight: .semibold)]).width + 24
        
        let height: CGFloat = 32
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
    }
    
}

// MARK: - GradientNavigationBarTitleTrait

extension EditItemViewController: GradientNavigationBarTitleTrait {}

// MARK: - Private functions

private extension EditItemViewController {
    
    // MARK: Setup
    
    func setupView() {
        view.backgroundColor = .white
        view.addGestureRecognizer(
            UITapGestureRecognizer(
                target: nil,
                action: #selector(UIView.endEditing(_:))
            )
        )
        
        deleteButton.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
    }
    
    func setupCollectionView() {
        labelsCollection.dataSource = self
        labelsCollection.delegate = self
        labelsCollection.register(LabelCell.self, forCellWithReuseIdentifier: LabelCell.identifier)
        labelsCollection.backgroundColor = .clear
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
                         labelsCollection,
                         deleteButton)
        
        NSLayoutConstraint.activate([
        editView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        editView.topAnchor.constraint(equalTo: view.topAnchor),
        editView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        
        labelsCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        labelsCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        labelsCollection.topAnchor.constraint(equalTo: editView.bottomAnchor, constant: 16),
        labelsCollection.bottomAnchor.constraint(equalTo: deleteButton.topAnchor, constant: 16),
        
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

