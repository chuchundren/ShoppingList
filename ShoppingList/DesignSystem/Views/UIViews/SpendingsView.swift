//
//  SpendingsView.swift
//  ShoppingList
//
//  Created by Dasha Palshau on 30.01.2022.
//

import UIKit

class SpendingsView: UIView {
    
    // MARK: - Private
    
    // MARK: UI
    
    private let header = UIView()
    private let dateLabel = makeLabel(for: .subtitle)
    private let spendingsLabel = makeLabel(for: .title)
    private let spendingsAmountLabel = makeLabel(for: .amount)
    private let balanceLabel = makeLabel(for: .title)
    private let balanceAmountLabel = makeLabel(for: .amount)
    private let averageDailyLabel = makeLabel(for: .title)
    
    // MARK: - Initializers
    
    init() {
        super.init(frame: .zero)
        
        setupView()
        setupSubviews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SpendingsView: ConfigurableView {
    
    func configure(with viewModel: ViewModel) {
        
    }
    
}

// MARK: - Private methods

private extension SpendingsView {
    
    // MARK: Setup
    
    func setupView() {
        backgroundColor = .white
    }
    
    func setupSubviews() {
        header.backgroundColor = .systemTeal
        dateLabel.text = "MON, Jan 31"
        spendingsLabel.text = "This week you spent:"
        spendingsAmountLabel.text = "54$"
        balanceLabel.text = "Leftover weekly budget:"
        balanceAmountLabel.text = "46$"
        averageDailyLabel.text = "On average 6,57$ a day"
    }
    
    // MARK: Layout
    
    func setupLayout() {
        addSubviews(header, spendingsLabel, spendingsAmountLabel, balanceLabel, balanceAmountLabel, averageDailyLabel)
        header.addSubviews(dateLabel)

		NSLayoutConstraint.activate([
			header.topAnchor.constraint(equalTo: topAnchor),
			header.leadingAnchor.constraint(equalTo: leadingAnchor),
            header.trailingAnchor.constraint(equalTo: trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: 28),
            
			dateLabel.topAnchor.constraint(equalTo: header.topAnchor, constant: LayoutConstants.defaultGap),
			dateLabel.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: LayoutConstants.mediumGap),
            
            spendingsLabel.topAnchor.constraint(equalTo: header.bottomAnchor, constant: LayoutConstants.defaultGap),
            spendingsLabel.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: -LayoutConstants.defaultGap),
            
            spendingsAmountLabel.centerYAnchor.constraint(equalTo: spendingsLabel.centerYAnchor),
            spendingsAmountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -LayoutConstants.largeGap),
            
            balanceLabel.topAnchor.constraint(equalTo: spendingsLabel.bottomAnchor, constant: LayoutConstants.mediumGap),
            balanceLabel.leadingAnchor.constraint(equalTo: spendingsLabel.leadingAnchor),
            
            balanceAmountLabel.centerYAnchor.constraint(equalTo: balanceLabel.centerYAnchor),
            balanceAmountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -LayoutConstants.largeGap),
            
            averageDailyLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -LayoutConstants.mediumGap),
            averageDailyLabel.leadingAnchor.constraint(equalTo: spendingsLabel.leadingAnchor)
        ])
    }
    
    static func makeLabel(for purpose: LabelPurpose) -> UILabel {
        let label = UILabel()
        label.textColor = .label
        
        switch purpose {
        case .subtitle:
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        case .title:
            label.font = UIFont.systemFont(ofSize: 19)
        case .amount:
            label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        }
        
        return label
    }

}

// MARK: - LabelPurpose

private extension SpendingsView {
    
    enum LabelPurpose {
        case subtitle, title, amount
    }
    
}

// MARK: - ViewModel

extension SpendingsView {
    
    struct ViewModel {
        let spendingsAmount: Double
    }
    
}
