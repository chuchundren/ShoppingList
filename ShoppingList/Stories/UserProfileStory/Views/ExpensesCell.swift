//
//  ExpensesCell.swift
//  ShoppingList
//
//  Created by Пальшау Дарья Денисовна [B] on 23.04.2022.
//

import UIKit

protocol UserExpensesCellDelegate: AnyObject {
	func didTapTimePeriodButton(sender: UIButton)
}

class ExpensesCell: UICollectionViewCell {
	
	let titleLabel = makeLabel(for: .title)
	let totalLabel = makeLabel(for: .text)
	let averageLabel = makeLabel(for: .text)
	let percentageLabel = makeLabel(for: .text)
	let timePeriodButton = UIButton(type: .system)
	
	weak var delegate: UserExpensesCellDelegate?
    
    // MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
	func setTimePeriod(_ period: TimePeriod) {
		setTitleText(for: period)
	}
    
}

// MARK: - Private functions
private extension ExpensesCell {
    
    func setupView() {
        addSubviews(titleLabel, totalLabel, averageLabel, percentageLabel, timePeriodButton)
		
		setTitleText(for: .thisWeek)
		timePeriodButton.addTarget(self, action: #selector(openPopover(sender:)), for: .touchUpInside)
		timePeriodButton.titleLabel?.font = .systemFont(ofSize: 20)
		totalLabel.text = "54.99 $"
		averageLabel.text = "On average 7.85 $ a day"
		percentageLabel.text = "16% more than last week"
    }
    
    func setupLayout() {
		NSLayoutConstraint.activate([
			titleLabel.top(equalTo: topAnchor, constant: LayoutConstants.defaultGap),
			titleLabel.leading(equalTo: leadingAnchor, constant: LayoutConstants.defaultGap),
			
			timePeriodButton.leading(equalTo: titleLabel.trailingAnchor, constant: LayoutConstants.smallGap),
			timePeriodButton.centerY(equalTo: titleLabel.centerYAnchor),
			
			totalLabel.top(equalTo: titleLabel.bottomAnchor, constant: LayoutConstants.semiMediumGap),
			totalLabel.leading(equalTo: titleLabel.leadingAnchor),
			
			averageLabel.top(equalTo: totalLabel.bottomAnchor, constant: LayoutConstants.defaultGap),
			averageLabel.leading(equalTo: totalLabel.leadingAnchor),
			
			percentageLabel.top(equalTo: averageLabel.bottomAnchor, constant: LayoutConstants.defaultGap),
			percentageLabel.leading(equalTo: totalLabel.leadingAnchor)
		])
    }
	
	func setTitleText(for timePeriod: TimePeriod) {
		switch timePeriod {
		case .today:
			titleLabel.text = "Your expenses"
			timePeriodButton.setTitle("today", for: .normal)
		case .thisWeek:
			titleLabel.text = "Your expenses this"
			timePeriodButton.setTitle("week", for: .normal)
		case .thisMonth:
			titleLabel.text = "Your expenses this"
			timePeriodButton.setTitle("month", for: .normal)
		case let .someOtherDay(date):
			guard let date = date else {
				return
			}

			titleLabel.text = "Your expenses on"
			timePeriodButton.setTitle(date.description, for: .normal)
		}
	}
	
	@objc func openPopover(sender: UIButton) {
		delegate?.didTapTimePeriodButton(sender: sender)
	}
	
	enum LabelPurpose {
		case title, text
	}
	
	static func makeLabel(for purpose: LabelPurpose) -> UILabel {
		let label = UILabel()
		switch purpose {
		case .title:
			label.font = .systemFont(ofSize: 20, weight: .semibold)
			label.textColor = .textMain
		case .text:
			label.font = .systemFont(ofSize: 18, weight: .medium)
			label.textColor = .systemTeal
		}
		
		return label
	}
    
}
