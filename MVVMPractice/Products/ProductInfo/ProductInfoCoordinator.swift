//
//  ProductInfoCoordinator.swift
//  MVVMPractice
//
//  Created by Ravshanbek Tursunbaev on 2023/03/28.
//

import UIKit

class ProductInfoCoordinator: Coordinator{
    
    private let viewModel: ProductInfoViewModel
    var childCoordinators: [Coordinator] = []
    var presenter: UINavigationController
    var product: Product?
    
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.viewModel = ProductInfoViewModel()
       
    }
    
    func start() {
        self.viewModel.product = product
        let vc = ProductInfoViewController(nibName: nil, bundle: nil)
        vc.productInfoViewModel = viewModel
        presenter.pushViewController(vc, animated: true)
    }
}
