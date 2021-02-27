//
//  InfoLabel.swift
//  SpaceX Tracker
//
//  Created by Maciej Matuszewski on 27/02/2021.
//

import UIKit
import Style

final class InfoLabel: UIStackView {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .style(.body)
        label.textColor = .style(.secondaryText)
        return label
    }()

    let valueLabel: UILabel = {
        let label = UILabel()
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

    public func configure(with configuration: InfoLabelConfiguration) {
        let viewModel = InfoLabelViewModelBuilder.build(with: configuration)
        titleLabel.text = viewModel.title
        valueLabel.text = viewModel.value
    }

    public func prepareForReuse() {
        titleLabel.text = nil
        valueLabel.text = nil
    }
}
