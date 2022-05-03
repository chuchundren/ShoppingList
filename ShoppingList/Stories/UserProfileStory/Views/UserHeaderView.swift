//
//  UserHeaderView.swift
//  ShoppingList
//
//  Created by Dasha Palshau on 30.01.2022.
//

import UIKit

class UserHeaderView: UICollectionReusableView {
    
    // MARK: - Private
    
    // MARK: UI
    
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let locationLabel = UILabel()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupView()
        setupSubviews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods

private extension UserHeaderView {
    
    // MARK: Setup
    
    func setupView() {
        backgroundColor = .bg
    }
    
    func setupSubviews() {
        avatarImageView.image = UIImage(systemName: "person.fill")
		avatarImageView.tintColor = .systemTeal
        nameLabel.text = "Chuchundren Michaelson"
        locationLabel.text = "Saint-Petersburg, Russia"
    }
    
    // MARK: Layout
    
    func setupLayout() {
        addSubviews(avatarImageView, nameLabel, locationLabel)
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            avatarImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            avatarImageView.heightAnchor.constraint(equalToConstant: 56),
            avatarImageView.widthAnchor.constraint(equalToConstant: 56),
            
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            locationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            locationLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            locationLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
    
}
