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
        interactor.fetchData()
        title = "Space X"
    }

    private func addComponents() {
        view.addSubview(tableView)
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
        guard interactor.viewModel.sections[section].isLoading else { return nil }
        let stackView = UIStackView()
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .style(.l)
        let activityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicatorView.color = .style(.accent)
        activityIndicatorView.startAnimating()
        stackView.addArrangedSubview(activityIndicatorView)
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
    func interactor(_ interactor: HomeInteractor, wantsToShowWebsiteWithURL url: URL) {
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true, completion: nil)
    }

    func interactor(_ interactor: HomeInteractor, wantsToShowError error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(.init(title: "Ok", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    func interactor(_ interactor: HomeInteractor, didUpdateViewModel viewModel: HomeViewModel) {
        tableView.reloadData()
    }
}
