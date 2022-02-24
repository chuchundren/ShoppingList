//
//  GoalsView.swift
//  ShoppingList
//
//  Created by Dasha Palshau on 16.02.2022.
//

import UIKit

class GoalsView: UIView {

    // MARK: - Private
    
    // MARK: UI
    
    private let yourGoalsLabel = UILabel()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: ListLayout())
    
    init() {
        super.init(frame: .zero)
        
        setupView()
        setupSubviews()
        setupCollectionView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension GoalsView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCell.identifier, for: indexPath) as? ListCell else {
            fatalError("Could not dequeue ListCell")
        }
        
        if indexPath.item == 0 {
            cell.configure(with: ListCell.ViewModel(listTitle: "- not buy junk food", description: nil))
        } else if indexPath.item == 1 {
            cell.configure(with: ListCell.ViewModel(listTitle: "- spend 20% less money", description: nil))
        }
    
        return cell
    }
    
}

// MARK: - Private methods

private extension GoalsView {
    
    func setupView() {
        backgroundColor = .systemTeal
    }
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.register(ListCell.self, forCellWithReuseIdentifier: ListCell.identifier)
    }
    
    func setupSubviews() {
        yourGoalsLabel.textColor = .white
        yourGoalsLabel.text = "Your goals this month:"
        yourGoalsLabel.font = .systemFont(ofSize: 20, weight: .medium)
    }
    
    func setupLayout() {
        addSubviews(yourGoalsLabel, collectionView)
        
        NSLayoutConstraint.activate([
            yourGoalsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            yourGoalsLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            
            collectionView.topAnchor.constraint(equalTo: yourGoalsLabel.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}
