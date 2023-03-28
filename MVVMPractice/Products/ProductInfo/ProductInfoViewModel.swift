//
//  ProductInfoViewModel.swift
//  MVVMPractice
//
//  Created by Ravshanbek Tursunbaev on 2023/03/28.
//

import UIKit

class ProductInfoViewModel: ObservableObject{
    private let apiManager: APIManager<String>
    var product: Product?
    
    init() {
        self.apiManager = APIManager()
    }
    
    func getImage()async -> UIImage?{
        var image: UIImage?
        guard let product else{return image}
        let imageURL = product.thumbnail
        do{
            let data = try await apiManager.fetchData(imageURL)
            let image = UIImage(data: data)
            return image
        }catch let error{
            print(error)
        }
        return image
    }
}
