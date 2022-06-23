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
    
}

class ListViewController: UIViewController {
    
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
        setupNavigationBar()
        setupLayout()
        
        presenter?.obtainItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureGradient(in: title)
    }
	
	override func didMove(toParent parent: UIViewController?) {
		super.didMove(toParent: parent)
		presenter?.didReturnToPreviousScreen()
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
        collectionView.reloadItems(at: [indexPath])
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
    
    func setupNavigationBar() {
        navigationItem.title = presenter?.title
        
        let plusButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItemButtonTapped))
        navigationItem.rightBarButtonItem = plusButton
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
    
    // MARK: 
    
    func presentNewItemAlert() {
        let alert = UIAlertController(title: "New item", message: "Enter item's title. \nYou will be able to edit it later", preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(
            UIAlertAction(title: "Add", style: .default, handler: { [weak self] _ in
                if let title = alert.textFields?.first?.text {
                    self?.presenter?.addItemWithTitle(title)
                }
            })
        )
        
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		present(alert, animated: true)
	}

	func showSheetController() {
		presenter?.didAskToAddNewItem()
	}
    
    // MARK: Selectors
    
    @objc func reload() {
        collectionView.reloadData()
    }
    
    @objc func addItemButtonTapped() {
        showSheetController()
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
        presenter?.didSelectItem(at: indexPath)
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
