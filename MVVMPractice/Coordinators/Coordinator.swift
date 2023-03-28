//
//  Coordinator.swift
//  MVVMPractice
//
//  Created by Ravshanbek Tursunbaev on 2023/03/27.
//

import UIKit

protocol Coordinator{
    var presenter: UINavigationController {get set}
    var childCoordinators: [Coordinator] {get set}
    func start()
}
