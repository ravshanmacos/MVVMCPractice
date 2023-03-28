//
//  User.swift
//  MVVMPractice
//
//  Created by Ravshanbek Tursunbaev on 2023/03/27.
//

import Foundation

struct User: Decodable{
    let id: Int
    let name: String
    let email: String
    let address: Address
}

struct Address: Decodable{
    let street: String
    let city: String
}
