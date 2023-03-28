//
//  ProductsCoordinator.swift
//  MVVMPractice
//
//  Created by Ravshanbek Tursunbaev on 2023/03/28.
//

import UIKit

class ProductsListCoordinator: Coordinator{
    
    var presenter: UINavigationController
    var childCoordinators: [Coordinator] = []
    private let productViewModel: ProductViewModel
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.productViewModel = ProductViewModel()
        setupListeners()
    }
    
    func start() {
        let tabbarData = getTabbarItemData()
        let vc = ProductsListViewController(nibName: nil, bundle: nil)
        vc.title = "Products"
        vc.productViewModel = productViewModel
        
        //tabbar item
        let tabbarItem = UITabBarItem()
        tabbarItem.title = tabbarData.title
        tabbarItem.image = tabbarData.image
        tabbarItem.selectedImage = tabbarData.imageSelected
        vc.tabBarItem = tabbarItem
        presenter.pushViewController(vc, animated: true)
    }
    
    
}

//MARK: - Tabbar Item Setup
extension ProductsListCoordinator{
    private func getTabbarItemData()->
    (title: String, image: UIImage, imageSelected: UIImage){
        let title = "Products"
        let image = UIImage.init(systemName: "cart")!
        let imageSelected = UIImage.init(systemName: "cart.fill")!
        return (title: title, image: image, imageSelected: imageSelected)
    }
}

//MARK: - Coordinating
extension ProductsListCoordinator{
    private func setupListeners(){
        productViewModel.onDeinit = { product in
            let vc = ProductInfoViewController(nibName: nil, bundle: nil)
            vc.product = product
            self.presenter.pushViewController(vc, animated: true)
        }
    }
}
