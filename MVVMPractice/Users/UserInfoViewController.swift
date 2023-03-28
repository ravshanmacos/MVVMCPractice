//
//  UserInfoViewController.swift
//  MVVMPractice
//
//  Created by Ravshanbek Tursunbaev on 2023/03/27.
//

import UIKit
import TinyConstraints

class UserInfoViewController: UIViewController {
    
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupViews()
    }
    
    
    private func setupViews(){
        guard let user else{return}
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 15
        
        let field1 = createInfoField(title: "Name", text: user.name)
        let field2 = createInfoField(title: "Email", text: user.email)
        let field3 = createInfoField(title: "City", text: user.address.city)
        let field4 = createInfoField(title: "Street", text: user.address.street)
        
        [field1,field2,field3,field4].forEach{stack.addArrangedSubview($0)}
        
        view.addSubview(stack)
        stack.topToSuperview(offset: 20,usingSafeArea: true)
        stack.leftToSuperview(offset: 20,usingSafeArea: true)
        stack.rightToSuperview(offset: -20,usingSafeArea: true)
    }
    
    private func createInfoField(title: String, text: String)-> UIStackView{
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        
        let label1 = UILabel()
        label1.text = title
        
        let label2 = UILabel()
        label2.textAlignment = .right
        label2.text = text
        
        stack.addArrangedSubview(label1)
        stack.addArrangedSubview(label2)
        return stack
    }

}
