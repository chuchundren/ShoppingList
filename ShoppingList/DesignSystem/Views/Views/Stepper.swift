//
//  Stepper.swift
//  ShoppingList
//
//  Created by Dasha Palshau on 01.03.2022.
//

import UIKit

class Stepper: UIControl {

	// MARK: - Private

	// MARK: UI

	private let plusButton = UIButton()
	private let minusButton = UIButton()
	private let valueLabel = UILabel()

	// MARK: Variables

	private var _value = 0 {
		didSet {
			valueLabel.text = String(value)
			sendActions(for: .valueChanged)
		}
	}

	// MARK: - Public

	var value: Int {
		get {
			if let min = minimalValue, min > _value {
				return min
			}

			return _value
		}
		set {
			if let min = minimalValue, newValue < min {
				_value = min
			}

			_value = newValue
		}

	}

	var minimalValue: Int?

	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setup() {
		plusButton.setImage(UIImage(systemName: "plus"), for: .normal)
		plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)

		minusButton.setImage(UIImage(systemName: "minus"), for: .normal)
		minusButton.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)

		valueLabel.text = String(value)
		valueLabel.textAlignment = .center

		backgroundColor = .bg
		layer.cornerRadius = 8
		
		setupLayout()
	}

	@objc private func plusButtonTapped() {
		value += 1
	}

	@objc private func minusButtonTapped() {
		value -= 1
	}

	private func setupLayout() {
		addSubviews(plusButton, valueLabel, minusButton,
					constraints: [
			plusButton.trailing(equalTo: trailingAnchor, constant: -8),
			plusButton.top(equalTo: topAnchor, constant: 8),
			plusButton.bottom(equalTo: bottomAnchor, constant: -8),

//			valueLabel.leading(equalTo: minusButton.trailingAnchor),
//			valueLabel.trailing(equalTo: plusButton.leadingAnchor),
			valueLabel.centerY(equalTo: centerYAnchor),
			valueLabel.centerX(equalTo: centerXAnchor),

			minusButton.top(equalTo: plusButton.topAnchor),
			minusButton.bottom(equalTo: plusButton.bottomAnchor),
			minusButton.leading(equalTo: leadingAnchor, constant: 8),

			widthAnchor.constraint(equalToConstant: 100)
		])

	}

}
