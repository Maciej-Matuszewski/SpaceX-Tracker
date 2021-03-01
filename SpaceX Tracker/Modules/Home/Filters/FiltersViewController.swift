//
//  FiltersViewController.swift
//  SpaceX Tracker
//
//  Created by Maciej Matuszewski on 28/02/2021.
//

import UIKit
import Style

protocol FiltersViewControllerDelegate: class {
    func viewController(_ viewController: FiltersViewController, wantsToUpdateFilters filters: Filters)
}

final class FiltersViewController: UIViewController {
    weak var delegate: FiltersViewControllerDelegate?
    private static let minYear: Int = 2006
    private static let maxYear: Int = Date.currentYear() + 2

    private var filters: Filters = .init(order: .ascending, status: .all, yearFrom: minYear, yearTo: maxYear)

    private let blurView: UIVisualEffectView = {
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.layer.cornerRadius = 16
        blurView.layer.masksToBounds = true
        return blurView
    }()

    private let rootStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = .style(.m)
        return stackView
    }()

    private let orderTitleLabel: UILabel = createLabel(with: Localized.FiltersViewController.Headers.order)

    private lazy var orderSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(
            items: [
                Filters.Order.ascending.rawValue,
                Filters.Order.descending.rawValue
            ]
        )
        segmentedControl.addTarget(self, action: #selector(orderSegmentedControlDidChangeValue(_:)), for: .valueChanged)
        return segmentedControl
    }()

    private let statusTitleLabel: UILabel = createLabel(with: Localized.FiltersViewController.Headers.status)

    private lazy var statusSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(
            items: [
                Filters.Status.all.rawValue,
                Filters.Status.successful.rawValue,
                Filters.Status.unsuccessful.rawValue,
            ]
        )
        segmentedControl.addTarget(self, action: #selector(statusSegmentedControlDidChangeValue(_:)), for: .valueChanged)
        return segmentedControl
    }()

    private let yearsTitleLabel: UILabel = createLabel(with: Localized.FiltersViewController.Headers.launchYears)

    private lazy var yearsPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()


    private let cancelBlurView: UIVisualEffectView = {
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterial))
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.layer.cornerRadius = 16
        blurView.layer.masksToBounds = true
        return blurView
    }()

    private lazy var updateButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Localized.FiltersViewController.Buttons.update, for: .normal)
        button.setTitleColor(.style(.accent), for: .normal)
        button.titleLabel?.font = .style(.button)
        button.addTarget(self, action: #selector(updateButtonDidTap(_:)), for: .touchUpInside)
        return button
    }()

    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Localized.FiltersViewController.Buttons.cancel, for: .normal)
        button.setTitleColor(.style(.accent), for: .normal)
        button.titleLabel?.font = .style(.button)
        button.addTarget(self, action: #selector(cancelButtonDidTap(_:)), for: .touchUpInside)
        return button
    }()

    private lazy var dismissGestureRecognizer: UITapGestureRecognizer = {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gestureRecognizerDidTap(_:)))
        gestureRecognizer.delegate = self
        return gestureRecognizer
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        addComponents()
        layoutComponents()
    }

    private func addComponents() {
        view.addGestureRecognizer(dismissGestureRecognizer)

        view.addSubview(blurView)
        blurView.contentView.addSubview(rootStackView)

        view.addSubview(cancelBlurView)
        cancelBlurView.contentView.addSubview(cancelButton)

        rootStackView.addArrangedSubviews(
            [
                orderTitleLabel,
                orderSegmentedControl,
                statusTitleLabel,
                statusSegmentedControl,
                yearsTitleLabel,
                yearsPickerView,
                updateButton
            ]
        )
    }

    private func layoutComponents() {
        NSLayoutConstraint.activate(
            [
                blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .style(.l)),
                blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.style(.l)),
                blurView.bottomAnchor.constraint(equalTo: cancelBlurView.topAnchor, constant: -.style(.l)),

                rootStackView.topAnchor.constraint(equalTo: blurView.topAnchor, constant: .style(.l)),
                rootStackView.leadingAnchor.constraint(equalTo: blurView.leadingAnchor, constant: .style(.l)),
                rootStackView.trailingAnchor.constraint(equalTo: blurView.trailingAnchor, constant: -.style(.l)),
                rootStackView.bottomAnchor.constraint(equalTo: blurView.bottomAnchor, constant: -.style(.l)),


                cancelBlurView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .style(.l)),
                cancelBlurView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.style(.l)),
                cancelBlurView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -.style(.l)),

                cancelButton.topAnchor.constraint(equalTo: cancelBlurView.topAnchor),
                cancelButton.leadingAnchor.constraint(equalTo: cancelBlurView.leadingAnchor),
                cancelButton.trailingAnchor.constraint(equalTo: cancelBlurView.trailingAnchor),
                cancelButton.bottomAnchor.constraint(equalTo: cancelBlurView.bottomAnchor),
                cancelButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 60)
            ]
        )

        rootStackView.setCustomSpacing(.style(.l), after: orderSegmentedControl)
        rootStackView.setCustomSpacing(.style(.l), after: statusSegmentedControl)
    }

    private static func createLabel(with title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = .style(.footnote)
        label.textColor = .style(.secondaryText)
        label.adjustsFontForContentSizeCategory = true
        return label
    }

    func configure(with filters: Filters) {
        self.filters = filters
        orderSegmentedControl.selectedSegmentIndex = filters.order.index
        statusSegmentedControl.selectedSegmentIndex = filters.status.index

        yearsPickerView.selectRow(filters.yearFrom - Self.minYear, inComponent: 0, animated: false)
        yearsPickerView.selectRow(filters.yearTo - Self.minYear, inComponent: 1, animated: false)
    }

    @objc private func orderSegmentedControlDidChangeValue(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: filters.order = .ascending
        default: filters.order = .descending
        }
    }

    @objc private func statusSegmentedControlDidChangeValue(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1: filters.status = .successful
        case 2: filters.status = .unsuccessful
        default: filters.status = .all
        }
    }

    @objc private func gestureRecognizerDidTap(_ sender: UITapGestureRecognizer) {
        guard sender.view == view else { return }
        dismiss(animated: true)
    }

    @objc private func cancelButtonDidTap(_ sender: UIButton) {
        dismiss(animated: true)
    }

    @objc private func updateButtonDidTap(_ sender: UIButton) {
        delegate?.viewController(self, wantsToUpdateFilters: filters)
        dismiss(animated: true)
    }
}

extension FiltersViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        Self.maxYear - Self.minYear + 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        "\(Self.minYear + row)"
    }
}

extension FiltersViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            if pickerView.selectedRow(inComponent: 1) < row {
                pickerView.selectRow(row, inComponent: 1, animated: true)
            }
            filters.yearFrom = row + Self.minYear

        case 1:
            if pickerView.selectedRow(inComponent: 0) > row {
                pickerView.selectRow(row, inComponent: 0, animated: true)
            }
            filters.yearTo = row + Self.minYear

        default: break
        }
    }
}

extension FiltersViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        touch.view == view
    }
}
