//
//  UIStackView+Array.swift
//  SpaceX Tracker
//
//  Created by Maciej Matuszewski on 01/03/2021.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { addArrangedSubview($0) }
    }
}
