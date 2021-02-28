//
//  ViewController.swift
//  SpaceX Tracker
//
//  Created by Maciej Matuszewski on 27/02/2021.
//

import UIKit
import Style
import SafariServices

class HomeViewController: UIViewController {
    typealias Context = ImageDownloaderProvider

    private let context: Context
    private let interactor: HomeInteractor

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .style(.accent)
        refreshControl.addTarget(self, action: #selector(refreshControlDidChanged(_:)), for: .valueChanged)
        return refreshControl
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(
            CompanyInfoCell.self,
            forCellReuseIdentifier: HomeViewModel.CellIdentifier.companyInfo.rawValue
        )
        tableView.register(
            LaunchCell.self,
            forCellReuseIdentifier: HomeViewModel.CellIdentifier.launch.rawValue
        )
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        return tableView
    }()

    init(interactor: HomeInteractor, context: Context) {
        self.interactor = interactor
        self.context = context
        super.init(nibName: nil, bundle: nil)
    }

    @available (*,unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .style(.primaryBackground)

        addComponents()
        layoutComponents()
        interactor.delegate = self
        interactor.initialFetch()
        title = Localized.HomeViewController.title
    }

    private func addComponents() {
        view.addSubview(tableView)
        navigationItem.rightBarButtonItem = .init(
            image: UIImage(systemName: "line.horizontal.3.decrease.circle"),
            style: .plain,
            target: self,
            action: #selector(filterButtonDidTap(_:))
        )
    }

    private func layoutComponents() {
        NSLayoutConstraint.activate(
            [
                tableView.topAnchor.constraint(equalTo: view.topAnchor),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ]
        )

        tableView.contentInset.bottom = view.safeAreaInsets.bottom
    }

    @objc private func filterButtonDidTap(_ sender: UIBarButtonItem) {
        interactor.showActionForFilterButton()
    }

    @objc private func refreshControlDidChanged(_ sender: UIRefreshControl) {
        interactor.initialFetch()
    }
}

extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        interactor.viewModel.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        interactor.viewModel.sections[section].items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = interactor.viewModel.sections[indexPath.section].items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier.rawValue, for: indexPath)

        switch item {
        case .companyInfo(let viewModel): (cell as? CompanyInfoCell)?.configure(with: viewModel)
        case .launch(let viewModel):  (cell as? LaunchCell)?.configure(with: viewModel, imageDownloader: context.imageDownloader)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        interactor.viewModel.sections[section].headerTitle
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let contentView: UIView
        switch interactor.viewModel.sections[section].footer {
        case .loadingIndicator:
            let activityIndicatorView = UIActivityIndicatorView(style: .medium)
            activityIndicatorView.color = .style(.accent)
            activityIndicatorView.startAnimating()
            contentView = activityIndicatorView
        case .emptyState(let text):
            let label = UILabel()
            label.numberOfLines = 0
            label.text = text
            label.textAlignment = .center
            label.textColor = .style(.secondaryText)
            label.font = .style(.footnote)
            contentView = label
        case .none: return nil
        }

        let stackView = UIStackView()
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .style(.l)
        stackView.addArrangedSubview(contentView)
        return stackView
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        guard section == 1 else { return }
        interactor.fetchNextPage()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        interactor.showActionForItem(at: indexPath)
    }
}

extension HomeViewController: HomeInteractorDelegate {
    func interactor(_ interactor: HomeInteractor, wantsToShowFiltersViewController filtersViewController: FiltersViewController) {
        present(filtersViewController, animated: true, completion: nil)
    }

    func interactor(_ interactor: HomeInteractor, wantsToShowOptionsViewController optionsViewController: OptionsAlertControler) {
        present(optionsViewController, animated: true, completion: nil)
    }

    func interactor(_ interactor: HomeInteractor, wantsToShowWebsiteWithURL url: URL) {
        present(SFSafariViewController(url: url), animated: true, completion: nil)
    }

    func interactor(_ interactor: HomeInteractor, wantsToShowError error: Error) {
        let alertController = UIAlertController(
            title: Localized.HomeViewController.ErrorAlert.title,
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alertController.addAction(
            .init(
                title: Localized.HomeViewController.ErrorAlert.buttonOk,
                style: .cancel,
                handler: nil
            )
        )
        present(alertController, animated: true, completion: nil)
        refreshControl.endRefreshing()
    }

    func interactor(_ interactor: HomeInteractor, didUpdateViewModel viewModel: HomeViewModel) {
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
}
