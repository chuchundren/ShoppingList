//
//  TimePeriodPopover.swift
//  ShoppingList
//
//  Created by Пальшау Дарья Денисовна [B] on 30.04.2022.
//

import UIKit

enum TimePeriod {
	case today
	case thisWeek
	case thisMonth
	case someOtherDay(_ date: Date?)
}

class TimePeriodPopover: UIViewController {
	
	let tableView = UITableView(frame: .zero, style: .plain)
	
	let timePeriods: [TimePeriod] = [.today, .thisWeek, .thisMonth, .someOtherDay(nil)]

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
		setupTableView()
		setupLayout()
    }
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		preferredContentSize = CGSize(width: 180, height: tableView.contentSize.height)
	}
    
}

private extension TimePeriodPopover {
	
	func setupView() {
		view.backgroundColor = .bg
		view.addSubviews(tableView)
		tableView.translatesAutoresizingMaskIntoConstraints = false
	}
	
	func setupTableView() {
		tableView.dataSource = self
		tableView.delegate = self
		tableView.backgroundColor = .clear
		tableView.isScrollEnabled = false
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
	}
	
	func setupLayout() {
		NSLayoutConstraint.activate([
			tableView.top(equalTo: view.topAnchor),
			tableView.bottom(equalTo: view.bottomAnchor),
			tableView.leading(equalTo: view.leadingAnchor),
			tableView.trailing(equalTo: view.trailingAnchor),
		])
	}
	
}

extension TimePeriodPopover: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		timePeriods.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier, for: indexPath)

		var content = cell.defaultContentConfiguration()
		content.textProperties.color = .textMain
		
		switch timePeriods[indexPath.row] {
		case .today:
			content.text =  "Today"
		case .thisWeek:
			content.text =  "This week"
		case .thisMonth:
			content.text =  "This month"
		case let .someOtherDay(date):
			if let date = date {
				
				#warning("Add formatting")
				if #available(iOS 15.0, *) {
					content.text = date.formatted()
				} else {
					content.text = date.description
				}
			} else {
				content.text = "Chose date..."
			}
		}

		cell.contentConfiguration = content
		
		return cell
	}
	
}

extension TimePeriodPopover: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		// Reload the data in expenses cell
		
		if indexPath.row == 3 {
			// Open calendar
		}
		
		dismiss(animated: true)
	}
	
}
