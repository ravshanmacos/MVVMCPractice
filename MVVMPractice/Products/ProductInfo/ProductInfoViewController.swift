//
//  ProductInfoViewController.swift
//  MVVMPractice
//
//  Created by Ravshanbek Tursunbaev on 2023/03/28.
//

import UIKit
import Combine
import TinyConstraints

class ProductInfoViewController: UIViewController {
    
    private var cancellables: [AnyCancellable] = []
    
    //optionals
    private var apiManager: APIManager<String>?
    @Published private var image: UIImage?
    var product: Product?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupPublishers()
        guard let product else{return}
        let apiManager = APIManager<String>(product.thumbnail)
        Task{
            do{
                let data = try await apiManager.fetchData()
                image = UIImage(data: data)
            }catch let error{
                print(error)
            }
        }
        self.apiManager = apiManager
        
    }
    
    private func setupPublishers(){
        $image
            .dropFirst(1)
            .sink { image in
                let imageView = UIImageView(image: image)
                imageView.contentMode = .scaleAspectFill
                self.view.addSubview(imageView)
                imageView.height(100)
                imageView.width(100)
                
                imageView.centerInSuperview()
            }.store(in: &cancellables)
    }

}
