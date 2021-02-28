//
//  SceneDelegate.swift
//  SpaceX Tracker
//
//  Created by Maciej Matuszewski on 27/02/2021.
//

import UIKit
import Style

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var appContext = AppContext()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)

        let homeInteractor = HomeInteractor(context: appContext)
        let homeViewController = HomeViewController(interactor: homeInteractor, context: appContext)

        window.rootViewController = UINavigationController(rootViewController: homeViewController)
        self.window = window
        window.makeKeyAndVisible()
        window.tintColor = .style(.accent)
    }

    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) { }
}

