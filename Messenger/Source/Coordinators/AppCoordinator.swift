//
//  AppCoordinator.swift
//  Messenger
//
//  Created by Maxim Kovalko on 8/11/19.
//  Copyright © 2019 Maxim Kovalko. All rights reserved.
//

import UIKit

extension AppCoordinator {
    enum Route {
        case chat
        
        var viewController: UIViewController {
            switch self {
            case .chat:
                return ModulesAssembly.createChatViewController()
            }
        }
    }
}

final class AppCoordinator {
    private let route: Route
    
    init(withRoute route: Route) {
        self.route = route
    }
    
    func makeInitialFlow() -> UIWindow {
        let window = UIWindow()
        window.rootViewController = UINavigationController(
            rootViewController: route.viewController
        )
        window.makeKeyAndVisible()
        return window
    }
}
