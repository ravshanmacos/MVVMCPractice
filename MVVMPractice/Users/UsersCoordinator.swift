//
//  MainCoordinator.swift
//  MVVMPractice
//
//  Created by Ravshanbek Tursunbaev on 2023/03/27.
//

import UIKit
import Combine

class UsersCoordinator: Coordinator{
    
    private let userViewModel: UserViewModel
    var presenter: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.userViewModel = UserViewModel()
        setupListeners()
    }
    
    func start() {
        let tabbarData = getTabbarItemData()
        let vc = UsersListViewController(nibName: nil, bundle: nil)
        vc.title = "Users"
        vc.userViewModel = userViewModel
        let tabbarItem = UITabBarItem()
        tabbarItem.title = tabbarData.title
        tabbarItem.image = tabbarData.image
        tabbarItem.selectedImage = tabbarData.imageSelected
        vc.tabBarItem = tabbarItem
        presenter.pushViewController(vc, animated: true)
    }

    deinit{
        print("Main coordinator deallocated")
    }
}

//MARK: - Tabbar Item Setup
extension UsersCoordinator{
    private func getTabbarItemData()->
    (title: String, image: UIImage, imageSelected: UIImage){
        let title = "Users"
        let image = UIImage.init(systemName: "person.2.circle")!
        let imageSelected = UIImage.init(systemName: "person.2.circle.fill")!
        return (title: title, image: image, imageSelected: imageSelected)
    }
}

//MARK: - Coordinating
extension UsersCoordinator{
    private func setupListeners(){
        userViewModel.onDeinit = { user in
            let vc = UserInfoViewController(nibName: nil, bundle: nil)
            vc.user = user
            self.presenter.pushViewController(vc, animated: true)
        }
    }
}
