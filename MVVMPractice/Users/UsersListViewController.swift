//
//  ViewController.swift
//  MVVMPractice
//
//  Created by Ravshanbek Tursunbaev on 2023/03/27.
//

import UIKit
import Combine
import TinyConstraints

class UsersListViewController: UIViewController {
    
    //MARK: - Properties
    
    //UI Properties
    private lazy var tableView = UITableView()
    private lazy var loadingSpinner: UIActivityIndicatorView = {
       let spinnerView = UIActivityIndicatorView()
        spinnerView.startAnimating()
        return spinnerView
    }()
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        label.text = "Oops! Something went wrong 😔"
        return label
    }()
    
    private let reuseIdentifier = "Cell"
    private var cancellables: [AnyCancellable] = []
    var userViewModel: UserViewModel?

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tabBarController?.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
        Task{
            guard let userViewModel else{return}
            await userViewModel.loadUsers()
        }
        
        setupPublishers()
    }
    
    private func setupPublishers(){
        guard let userViewModel else{return}
        userViewModel.$usersState.sink {[weak self] state in
            guard let self = self else{return}
            DispatchQueue.main.async {
                self.view.subviews.forEach{$0.removeFromSuperview()}
                switch state{
                case .loading:
                    self.addSpinnerView()
                case .finishedWithSuccess:
                    self.addTableView()
                    self.tableView.reloadData()
                case .finishedWithError:
                    self.addErrorLabel()
                case .none:
                    break
                }
            }
        }.store(in: &cancellables)
    }
}

//MARK: - UI Helper Methods
extension UsersListViewController{
    
    //Add Table View
    private func addTableView(){
        view.addSubview(tableView)
        tableView.edgesToSuperview(usingSafeArea: true)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    //Add Spinner View
    private func addSpinnerView(){
        view.addSubview(loadingSpinner)
        loadingSpinner.centerInSuperview()
    }
    
    //Add Error Label
    private func addErrorLabel(){
        view.addSubview(errorLabel)
        errorLabel.centerInSuperview()
    }
}

//MARK: - UITableViewDataSource
extension UsersListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let userViewModel else{return 0}
        let count = userViewModel.getUsersName().count
        return count > 0 ? count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        guard let userViewModel else{return cell}
        let users = userViewModel.getUsers()
        let user = users[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = user.name
        content.secondaryText = user.email
        cell.contentConfiguration = content
        return cell
    }
    
    
}

//MARK: - UITableViewDelegate
extension UsersListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer{tableView.deselectRow(at: indexPath, animated: true)}
        guard let userViewModel else{return}
        let users = userViewModel.getUsers()
        let user = users[indexPath.row]
        userViewModel.selectedUser = user
         
    }
}

