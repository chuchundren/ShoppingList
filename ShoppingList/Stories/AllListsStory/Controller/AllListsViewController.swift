//
//  AllListsViewController.swift
//  ShoppingList
//
//  Created by Dasha Palshau on 16.10.2021.
//

import UIKit

protocol AllListsScreen: AnyObject {
    func configure(with viewModels: [ListCell.ViewModel])
}

class AllListsViewController: BaseScreen {
    
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: ListLayout()
    )
    
    var shoppingLists: [ListCell.ViewModel] = []
    
    var presenter: AllListsScreenOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupCollectionView()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureGradient(in: title)
    }
    
}


// MARK: - AllListsControllerProtocol

extension AllListsViewController: AllListsScreen {
    
    func configure(with viewModels: [ListCell.ViewModel]) {
        shoppingLists = viewModels
        collectionView.reloadData()
    }
    
}


// MARK: - UICollectionViewDataSource

extension AllListsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shoppingLists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ListCell.identifier,
                for: indexPath) as? ListCell else {
            return UICollectionViewCell()
        }
        
        let list = shoppingLists[indexPath.item]
        
        cell.configure(with: list)
        return cell
    }
    
}

extension AllListsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let list = shoppingLists[indexPath.item]
        list.select()
    }
    
}

// MARK: - ListLayoutDelegate

extension AllListsViewController: ListLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, width: CGFloat, heightForItemAtIndexPath indexPath: IndexPath) -> CGFloat {
        return ListCell().measureHeight(
            model: shoppingLists[indexPath.item],
            width: width
        )
    }
    
}


// MARK: - GradientNavigationBarTitleTrait

extension AllListsViewController: GradientNavigationBarTitleTrait {}

// MARK: - Private functions

extension AllListsViewController {
    
    func setupView() {
        view.backgroundColor = .bg
        
    }
    
    // MARK: Setup
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ListCell.self, forCellWithReuseIdentifier: ListCell.identifier)
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        
        if let layout = collectionView.collectionViewLayout as? ListLayout {
            layout.delegate = self
        }
    }
    
    // MARK: Layout
    
    func setupLayout() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
}
