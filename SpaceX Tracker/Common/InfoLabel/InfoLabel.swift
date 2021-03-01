//
//  InfoLabel.swift
//  SpaceX Tracker
//
//  Created by Maciej Matuszewski on 27/02/2021.
//

import UIKit
import Style

final class InfoLabel: AdaptiveStackView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .style(.body)
        label.textColor = .style(.secondaryText)
        return label
    }()

    private let valueLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .style(.body)
        label.textColor = .style(.primaryText)
        return label
    }()

    init() {
        super.init(frame: .zero)
        addComponents()
        layoutComponents()
        spacing = .style(.m)
    }

    @available (*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addComponents() {
        addArrangedSubview(titleLabel)
        addArrangedSubview(valueLabel)
    }

    private func layoutComponents() {
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        valueLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        valueLabel.setContentHuggingPriority(.required, for: .horizontal)
        valueLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }

    func configure(with viewModel: InfoLabelViewModel) {
        titleLabel.text = viewModel.title
        valueLabel.text = viewModel.value
    }

    func prepareForReuse() {
        titleLabel.text = nil
        valueLabel.text = nil
    }
}
