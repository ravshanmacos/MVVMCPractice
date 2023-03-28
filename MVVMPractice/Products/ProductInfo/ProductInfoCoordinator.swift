//
//  ProductInfoCoordinator.swift
//  MVVMPractice
//
//  Created by Ravshanbek Tursunbaev on 2023/03/28.
//

import UIKit

class ProductInfoCoordinator: Coordinator{
    
    var childCoordinators: [Coordinator]
    var presenter: UINavigationController
    private let viewModel: ProductInfoViewModel
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
        viewModel = ProductInfoViewModel()
    }
    
    func start() {
        <#code#>
    }
}
