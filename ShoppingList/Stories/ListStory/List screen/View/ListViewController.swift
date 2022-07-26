//
//  ListViewController.swift
//  ShoppingList
//
//  Created by Dasha Palshau on 21.09.2021.
//

import UIKit

protocol ListScreen: AnyObject {
    
    func configureCells(with items: [ListCell.ViewModel])
    func reloadCell(at indexPath: IndexPath, with item: ListCell.ViewModel)
    func insertItem(_ item: ListCell.ViewModel, at index: Int)
    func configureTitle(_ title: String)
    
}

class ListViewController: BaseScreen {
    
    // MARK: - Private
    
    // MARK: UI
    
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: ListLayout()
    )
    
    // MARK: Variables
    
    private var items: [ListCell.ViewModel] = []
    
    // MARK: - Public
    
    // MARK: Variables
    
    var presenter: ListScreenOutput?
    
    // MARK: - Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .bg
        
        setupCollectionView()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureGradient(in: title)
    }
    
}

// MARK: - ListControllerProtocol

extension ListViewController: ListScreen {
    
    func insertItem(_ item: ListCell.ViewModel, at index: Int) {
        items.insert(item, at: index)
        collectionView.reloadData()
    }
    
    func configureCells(with items: [ListCell.ViewModel]) {
        self.items = items
        collectionView.reloadData()
    }
    
    func reloadCell(at indexPath: IndexPath, with item: ListCell.ViewModel) {
        items[indexPath.item] = item
		UIView.performWithoutAnimation {
			collectionView.reloadItems(at: [indexPath])
		}

    }
    
    func configureTitle(_ title: String) {
        self.title = title
        configureGradient(in: title)
    }
    
}

// MARK: - GradientNavigationBarTitleTrait

extension ListViewController: GradientNavigationBarTitleTrait {}

// MARK: - Private functions

private extension ListViewController {
    
    // MARK: Setup
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ListCell.self, forCellWithReuseIdentifier: ListCell.identifier)
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        
        if let layout = collectionView.collectionViewLayout as? ListLayout {
            layout.delegate = self
        }
    }
    
    // MARK: Layout
    
    func setupLayout() {
        view.addSubviews(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
}

// MARK: - UICollectionViewDataSource

extension ListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ListCell.identifier,
                for: indexPath) as? ListCell else {
            return UICollectionViewCell()
        }
        
        let item = items[indexPath.item]
        
        cell.configure(with: item)
        
        return cell
    }

}

// MARK: - UICollectionViewDelegate

extension ListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.item]
        item.select()
    }
}

// MARK: - ListLayoutDelegate

extension ListViewController: ListLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, width: CGFloat, heightForItemAtIndexPath indexPath: IndexPath) -> CGFloat {
        return ListCell().measureHeight(
            model: items[indexPath.item],
            width: width
        )
    }
    
}
