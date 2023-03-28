//
//  TabbarCoordinator.swift
//  MVVMPractice
//
//  Created by Ravshanbek Tursunbaev on 2023/03/28.
//

import UIKit

class TabbarCoordinator: Coordinator{
    
    var presenter: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
    }
    
    func start() {
        let vc = TabbarViewController(nibName: nil, bundle: nil)
        presenter.pushViewController(vc, animated: true)
    }
    
    
}
