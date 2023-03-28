//
//  ProductViewModel.swift
//  MVVMPractice
//
//  Created by Ravshanbek Tursunbaev on 2023/03/28.
//

import Foundation
import Combine

class ProductViewModel: ObservableObject{
    private let apiManager: APIManager<Products>
    private let urlString = "https://dummyjson.com/products"
    private var products: [Product] = []
    private var cancellables: [AnyCancellable] = []
    
    var onDeinit:((_ product: Product)->Void)?
    @Published var selectedProduct: Product?
    @Published var productsState: ProductViewModelState?
    
    init() {
        self.apiManager = APIManager()
        setupPublishers()
    }
    
    func loadProducts()async{
        do {
            productsState = .loading
            let data = try await apiManager.fetchData(urlString)
            let products = try apiManager.decodeObject(data: data)
            self.products = products.products
            productsState = .finishedWithSuccess
        } catch let error {
            print("error loading users \(error)")
            productsState = .finishedWithError
        }
    }
    
    func getProducts()-> [Product]{
        return products
    }
}

extension ProductViewModel{
    private func setupPublishers(){
        $selectedProduct
            .dropFirst(1)
            .sink {[weak self] product in
            guard let self = self, let product = product else {return}
                self.onDeinit?(product)
        }.store(in: &cancellables)
    }
}

extension ProductViewModel{
    enum ProductViewModelState{
        case loading
        case finishedWithSuccess
        case finishedWithError
    }
}
