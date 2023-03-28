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
    //UI properties
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
    
    private var cancellables: [AnyCancellable] = []
    var productInfoViewModel: ProductInfoViewModel?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setupPublishers()
    }
    
    private func configureView(){
        view.backgroundColor = .white
        Task{
            guard let productInfoViewModel else{return}
            await productInfoViewModel.loadImage()
        }
    }
    
    private func setupPublishers(){
        guard let productInfoViewModel else{return}
        productInfoViewModel.$imageState.sink { state in
            DispatchQueue.main.async {
                self.view.subviews.forEach{$0.removeFromSuperview()}
                switch state{
                case .loading:
                    self.addSpinnerView()
                case .finishedWithSuccess:
                    guard let image = productInfoViewModel.getImage() else{return}
                    self.addImageView(with: image)
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

extension ProductInfoViewController{
    //Add Spinner View
    private func addSpinnerView(){
        view.addSubview(loadingSpinner)
        loadingSpinner.centerInSuperview()
    }
    //Add Image View
    private func addImageView(with image: UIImage){
        let imageView = UIImageView(image: image)
        imageView.backgroundColor = .red
        imageView.contentMode = .scaleAspectFill
        self.view.addSubview(imageView)
        imageView.centerInSuperview()
        imageView.width(300)
        imageView.height(200)
    }
    
    //Add Error Label
    private func addErrorLabel(){
        view.addSubview(errorLabel)
        errorLabel.centerInSuperview()
    }
}
