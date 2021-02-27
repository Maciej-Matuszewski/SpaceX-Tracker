//
//  ViewController.swift
//  SpaceX Tracker
//
//  Created by Maciej Matuszewski on 27/02/2021.
//

import UIKit
import Style

class ViewController: UIViewController {
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .style(.primaryBackground)

        addComponents()
        layoutComponents()
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

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "Section: \(indexPath.section), Row: \(indexPath.row)"
        return cell
    }
}

extension ViewController: UITableViewDelegate { }
