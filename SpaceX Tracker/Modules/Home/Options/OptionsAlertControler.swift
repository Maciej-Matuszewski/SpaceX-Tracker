//
//  OptionsAlertControler.swift
//  SpaceX Tracker
//
//  Created by Maciej Matuszewski on 28/02/2021.
//

import UIKit

protocol OptionsAlertControlerDelegate: class {
    func alertController(_ alertController: OptionsAlertControler, wantsToShowWebsiteWithURL url: URL)
}

final class OptionsAlertControler: UIAlertController {
    weak var delegate: OptionsAlertControlerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        addAction(.init(title: Localized.Options.cancel, style: .cancel, handler: nil))
    }

    func addAction(title: String, url: URL) {
        let action = UIAlertAction(title: title, style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.alertController(self, wantsToShowWebsiteWithURL: url)
        }
        addAction(action)
    }
}
