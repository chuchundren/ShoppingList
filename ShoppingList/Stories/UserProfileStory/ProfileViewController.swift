//
//  UserProfileViewController.swift
//  ShoppingList
//
//  Created by Dasha Palshau on 18.11.2021.
//

import UIKit

protocol ProfileScreen: UIPopoverPresentationControllerDelegate {
	func reloadData()
}

class ProfileViewController: UIViewController {
    
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: CompositionalLayout.makeLayout()
    )
	
	var presenter: ProfileScreenOutput?
	var timePeriod: TimePeriod = .thisWeek

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupCollectionView()
        setupLayout()
    }
    
}

extension ProfileViewController: ProfileScreen {
	
	func reloadData() {
		collectionView.reloadData()
	}
	
	func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
		return .none
	}
	
}

extension ProfileViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExpensesCell.identifier,
                                                            for: indexPath) as? ExpensesCell else {
            fatalError("Could not dequeue CardCell")
        }
		cell.setTimePeriod(timePeriod)
		cell.delegate = self
		
        return cell
        
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

extension ProfileViewController: GradientNavigationBarTitleTrait {}

extension ProfileViewController: UserExpensesCellDelegate {
	
	func didTapTimePeriodButton(sender: UIButton) {
		presenter?.didTapSelectTimePeriodButton(sender: sender)
	}
}


// MARK: - Private methods

private extension ProfileViewController {
    
    func setupView() {
        title = "Profile"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .plain,
            target: self,
            action: #selector(openSettings)
        )
        
		navigationController?.navigationBar.tintColor = .systemTeal
        view.backgroundColor = .bg
        configureGradient(in: title)
    }
    
    func setupCollectionView() {
        collectionView.backgroundColor = .bg
        collectionView.dataSource = self
        
        collectionView.register(ExpensesCell.self, forCellWithReuseIdentifier: ExpensesCell.identifier)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(
            UserHeaderView.self,
            forSupplementaryViewOfKind: SupplementaryViewKind.header.rawValue,
            withReuseIdentifier: UserHeaderView.identifier
        )
        collectionView.alwaysBounceVertical = false
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
		presenter?.didTapSettingsBarButton()
	}
    
}
