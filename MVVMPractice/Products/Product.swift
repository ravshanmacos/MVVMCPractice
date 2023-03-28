//
//  Product.swift
//  MVVMPractice
//
//  Created by Ravshanbek Tursunbaev on 2023/03/28.
//

import Foundation

struct Products: Decodable{
    let products: [Product]
    let total: Int
}

struct Product: Decodable{
    let id: Int
    let title: String
    let price: Int
    let discountPercentage: Float
    let rating: Float
    let brand: String
    let category: String
    let thumbnail: String
}


