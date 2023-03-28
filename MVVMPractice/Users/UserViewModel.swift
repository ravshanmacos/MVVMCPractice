//
//  UserViewModel.swift
//  MVVMPractice
//
//  Created by Ravshanbek Tursunbaev on 2023/03/27.
//

import Foundation
import Combine

class UserViewModel: ObservableObject{
    
    //MARK: - Properties
    private let apiManager: APIManager<User>
    private var users: [User] = []
    private var cancellables: [AnyCancellable] = []
    private let urlString = "https://jsonplaceholder.typicode.com/users"
    var onDeinit:((_ user: User)->Void)?
    
    @Published var selectedUser: User?
    @Published var usersState: UserViewModelState?
    
    //MARK: - Life Cycle
    init() {
        self.apiManager = APIManager()
        setupPublisher()
    }
    
    func loadUsers()async{
        do {
            usersState = .loading
            let data = try await apiManager.fetchData(urlString)
            users = try apiManager.decodeArrayOfData(data: data)
            usersState = .finishedWithSuccess
        } catch let error {
            print("error loading users \(error)")
            usersState = .finishedWithError
        }
    }
    
    func getUsers()-> [User]{
        return users
    }
    
    func getUsersName()->[String]{
        return users.map { $0.name }
    }
    
    deinit {
        print("User view model deallocated")
    }
}

extension UserViewModel{
    private func setupPublisher(){
        $selectedUser
            .dropFirst(1)
            .sink {[weak self] user in
            guard let self = self, let user = user else {return}
                self.onDeinit?(user)
        }.store(in: &cancellables)
    }
}


extension UserViewModel{
    enum UserViewModelState{
        case loading
        case finishedWithSuccess
        case finishedWithError
    }
}
