//
//  LaunchCell.swift
//  SpaceX Tracker
//
//  Created by Maciej Matuszewski on 27/02/2021.
//

import UIKit
import Style

final class LaunchCell: UITableViewCell {
    private var currentImageFetchTask: URLSessionTask?

    private let rootStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .style(.m)
        stackView.spacing = .style(.m)
        return stackView
    }()

    private var missionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .style(.accent)
        return imageView
    }()

    private var statusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .style(.accent)
        return imageView
    }()

    private let labelsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = UIStackView.spacingUseSystem
        return stackView
    }()

    private let missionLabel = InfoLabel()
    private let dateLabel = InfoLabel()
    private let rocketLabel = InfoLabel()
    private let daysSinceNowLabel = InfoLabel()

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
        addSubview(rootStackView)
        rootStackView.addArrangedSubviews([missionImageView, labelsStackView, statusImageView])
        labelsStackView.addArrangedSubviews([missionLabel, dateLabel, rocketLabel, daysSinceNowLabel])
    }

    private func layoutComponents() {
        NSLayoutConstraint.activate(
            [
                rootStackView.topAnchor.constraint(equalTo: topAnchor),
                rootStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
                rootStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                rootStackView.trailingAnchor.constraint(equalTo: trailingAnchor),

                missionImageView.widthAnchor.constraint(equalToConstant: .style(iconSize: .medium)),
                missionImageView.heightAnchor.constraint(equalToConstant: .style(iconSize: .medium)),

                statusImageView.widthAnchor.constraint(equalToConstant: .style(iconSize: .small)),
                statusImageView.heightAnchor.constraint(equalToConstant: .style(iconSize: .small))
            ]
        )
        missionImageView.setContentHuggingPriority(.required, for: .horizontal)
        statusImageView.setContentHuggingPriority(.required, for: .horizontal)
    }

    public func configure(with viewModel: LaunchCellViewModel, imageDownloader: ImageDownloaderProtocol) {
        missionImageView.image = UIImage(systemName: "photo")

        currentImageFetchTask = imageDownloader.image(from: viewModel.missionImageURL) { [weak self] (image) in
            guard let image = image else { return }
            self?.missionImageView.image = image
        }

        statusImageView.image = viewModel.statusImage.image
        missionLabel.configure(with: viewModel.missionLabelViewModel)
        dateLabel.configure(with: viewModel.dateLabelViewModel)
        rocketLabel.configure(with: viewModel.rocketLabelViewModel)
        daysSinceNowLabel.configure(with: viewModel.daysSinceNowLabelViewModel)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        currentImageFetchTask?.cancel()
        missionImageView.image = nil
        statusImageView.image = nil
        missionLabel.prepareForReuse()
        dateLabel.prepareForReuse()
        rocketLabel.prepareForReuse()
        daysSinceNowLabel.prepareForReuse()
    }
}

fileprivate extension LaunchCellViewModel.StatusImage {
    var image: UIImage? {
        switch self {
        case .success:
            return UIImage(systemName: "hand.thumbsup.fill")
        case .failed:
            return UIImage(systemName: "hand.thumbsdown.fill")
        case .waiting:
            return UIImage(systemName: "clock.fill")
        }
    }
}
