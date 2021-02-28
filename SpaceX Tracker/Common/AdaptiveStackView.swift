//
//  AdaptiveStackView.swift
//  SpaceX Tracker
//
//  Created by Maciej Matuszewski on 28/02/2021.
//

import UIKit

class AdaptiveStackView: UIStackView {
    @available(*, unavailable)
    override var axis: NSLayoutConstraint.Axis {
        get {
            return super.axis
        }
        set {
            assertionFailure("AdaptiveStackView is handling axis by itself and setting new value is not allowed.")
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        updateAxis()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        updateAxis()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateAxis()
    }

    private func updateAxis() {
        super.axis = traitCollection.preferredContentSizeCategory > UIContentSizeCategory.extraExtraLarge ? .vertical : .horizontal
    }
}
