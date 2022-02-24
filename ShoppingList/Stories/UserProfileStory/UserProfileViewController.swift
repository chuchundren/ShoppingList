//
//  UserProfileViewController.swift
//  ShoppingList
//
//  Created by Dasha Palshau on 18.11.2021.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: CompositionalLayout.makeLayout()
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupSubviews()
        setupLayout()
    }
    
}

extension UserProfileViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CardCell.identifier,
                for: indexPath
            ) as? CardCell else {
                fatalError("Could not dequeue CardCell")
            }
            
            if indexPath.item == 0 {
                cell.configure(with: CardCell.ViewModel(view: GoalsView()))
            } else if indexPath.item == 1 {
                cell.configure(with: CardCell.ViewModel(view: SpendingsView()))
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "cell",
                for: indexPath
            )
            
            cell.backgroundColor = .systemTeal
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: SupplementaryViewKind.header.rawValue,
                withReuseIdentifier: UserHeaderView.identifier,
                for: indexPath
        ) as? UserHeaderView else {
            return UICollectionReusableView()
        }
        
        return header
    }
    
}

// MARK: - GradientNavigationBarTitleTrait

extension UserProfileViewController: GradientNavigationBarTitleTrait {}

// MARK: - Private methods

private extension UserProfileViewController {
    
    func setupView() {
        title = "Profile"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .plain,
            target: self,
            action: #selector(openSettings)
        )
        
        view.backgroundColor = .bg
        configureGradient(in: title)
    }
    
    func setupSubviews() {
        collectionView.backgroundColor = .bg
        collectionView.dataSource = self
        
        collectionView.register(CardCell.self, forCellWithReuseIdentifier: CardCell.identifier)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(
            UserHeaderView.self,
            forSupplementaryViewOfKind: SupplementaryViewKind.header.rawValue,
            withReuseIdentifier: UserHeaderView.identifier
        )
    }
    
    func setupLayout() {
        view.addSubviews(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    @objc func openSettings() {
        
    }
    
}
