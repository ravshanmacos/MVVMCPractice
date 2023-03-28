//
//  ApplicationCoordinator.swift
//  MVVMPractice
//
//  Created by Ravshanbek Tursunbaev on 2023/03/27.
//

import UIKit

class ApplicationCoordinator: Coordinator{
    
    var presenter: UINavigationController
    private var rootCoordinator: Coordinator
    
    var childCoordinators: [Coordinator] = []
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        self.presenter = UINavigationController()
        self.rootCoordinator = TabbarCoordinator(presenter: presenter)
    }
    
    func start() {
        window.rootViewController = presenter
        rootCoordinator.start()
        window.makeKeyAndVisible()
    }
}
