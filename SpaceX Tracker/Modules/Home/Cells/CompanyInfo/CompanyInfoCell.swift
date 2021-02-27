//
//  CompanyInfoCell.swift
//  SpaceX Tracker
//
//  Created by Maciej Matuszewski on 27/02/2021.
//

import UIKit
import Style

final class CompanyInfoCell: UITableViewCell {
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .style(.primaryText)
        label.font = .style(.body)
        label.numberOfLines = 0
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .style(.secondaryBackground)
        
        addComponents()
        layoutComponents()
    }

    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addComponents() {
        addSubview(label)
    }

    private func layoutComponents() {
        NSLayoutConstraint.activate(
            [
                label.topAnchor.constraint(equalTo: topAnchor, constant: .style(.m)),
                label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.style(.m)),
                label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .style(.m)),
                label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.style(.m))
            ]
        )
    }

    public func configure(with viewModel: CompanyInfoCellViewModel) {
        label.text = viewModel.labelText
    }
}
