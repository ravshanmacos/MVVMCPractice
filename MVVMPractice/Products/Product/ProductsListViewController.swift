//
//  ProductsListViewController.swift
//  MVVMPractice
//
//  Created by Ravshanbek Tursunbaev on 2023/03/28.
//

import UIKit
import Combine
import TinyConstraints

class ProductsListViewController: UIViewController {
    
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
    var productViewModel: ProductViewModel?

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        tabBarController?.navigationController?.isNavigationBarHidden = true
        Task{
            guard let productViewModel else{return}
            await productViewModel.loadProducts()
        }
        
        setupPublishers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.navigationItem.title = "Products"
    }
    
    private func setupPublishers(){
        guard let productViewModel else{return}
        productViewModel.$productsState.sink {[weak self] state in
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
extension ProductsListViewController{
    
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
extension ProductsListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let productViewModel else{return 0}
        let count = productViewModel.getProducts().count
        return count > 0 ? count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        guard let productViewModel else{return cell}
        let products = productViewModel.getProducts()
        let product = products[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = product.title
        content.secondaryText = product.brand
        cell.contentConfiguration = content
        return cell
    }
    
    
}

//MARK: - UITableViewDelegate
extension ProductsListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer{tableView.deselectRow(at: indexPath, animated: true)}
        guard let productViewModel else{return}
        let products = productViewModel.getProducts()
        let product = products[indexPath.row]
        productViewModel.selectedProduct = product
         
    }
}
