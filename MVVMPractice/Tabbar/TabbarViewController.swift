//
//  TabbarViewController.swift
//  MVVMPractice
//
//  Created by Ravshanbek Tursunbaev on 2023/03/28.
//

import UIKit

class TabbarViewController: UITabBarController{
    let usersCoordinator = UsersCoordinator(presenter: UINavigationController())
    let productsCoordinator = ProductsListCoordinator(presenter: UINavigationController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStarters()
        setupTabbarControllers()
    }
    
    private func setupStarters(){
        usersCoordinator.start()
        productsCoordinator.start()
    }
    
    private func setupTabbarControllers(){
        viewControllers = [
            usersCoordinator.presenter,
            productsCoordinator.presenter
        ]
    }
}
