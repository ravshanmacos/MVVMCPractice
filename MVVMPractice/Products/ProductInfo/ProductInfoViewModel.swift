//
//  ProductInfoViewModel.swift
//  MVVMPractice
//
//  Created by Ravshanbek Tursunbaev on 2023/03/28.
//

import UIKit

class ProductInfoViewModel: ObservableObject{
    private let apiManager: APIManager<String>
    private var image: UIImage?
    var product: Product?
    @Published var imageState: ImageState?
    
    init() {
        self.apiManager = APIManager()
    }
    
    func loadImage()async{
        guard let product else{
            imageState = .finishedWithError;
            return
        }
        let imageURL = product.thumbnail
        imageState = .loading
        do{
            let data = try await apiManager.fetchData(imageURL)
            image = UIImage(data: data)
            imageState = .finishedWithSuccess
        }catch let error{
            print(error)
            imageState = .finishedWithError
        }
    }
    
    func getImage()-> UIImage?{
        return image
    }
}

extension ProductInfoViewModel{
    enum ImageState{
        case loading
        case finishedWithSuccess
        case finishedWithError
    }
}
