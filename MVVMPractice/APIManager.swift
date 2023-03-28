//
//  ApiManager.swift
//  MVVMPractice
//
//  Created by Ravshanbek Tursunbaev on 2023/03/27.
//

import Foundation

class APIManager<T: Decodable>{
    private let urlSession: URLSession
    private let urlSessionConfiguration: URLSessionConfiguration
    
    init() {
        self.urlSessionConfiguration = URLSessionConfiguration.default
        self.urlSession = URLSession(configuration: urlSessionConfiguration)
    }
    
    func fetchData(_ urlString: String)async throws -> Data{
        guard let url = URL(string: urlString) else{
            throw APIManagerError.invalidURL
        }
        let (data,response) = try await urlSession.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else{
            throw APIManagerError.invalidResponse
        }
        return data
    }
    
    func decodeArrayOfData(data: Data)throws-> [T]{
        do {
            let decoder = JSONDecoder()
           let fetchedData = try decoder.decode([T].self, from: data)
            return fetchedData
        } catch {
            throw APIManagerError.failedToDecodeData
        }
    }
    
    func decodeObject(data: Data)throws-> T{
        do {
            let decoder = JSONDecoder()
           let fetchedData = try decoder.decode(T.self, from: data)
            return fetchedData
        } catch let error {
            print(error)
            throw APIManagerError.failedToDecodeData
        }
    }
}

extension APIManager{
    enum APIManagerError: Error{
        case invalidURL
        case invalidResponse
        case failedToDecodeData
    }
}

