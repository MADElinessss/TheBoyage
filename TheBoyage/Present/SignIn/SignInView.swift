//
//  SignInView.swift
//  TheBoyage
//
//  Created by Madeline on 4/11/24.
//

import SnapKit
import UIKit

class SignInView: BaseView {
    
    let emailTextField = {
        let view = UITextField()
        view.placeholder = " 아이디(이메일)"
        view.font = .systemFont(ofSize: 14, weight: .medium)
        view.backgroundColor = .white
        view.layer.borderWidth = 0.3
        view.tintColor = .point
        return view
    }()
    
    let passwordTextField = {
        let view = UITextField()
        view.placeholder = " 비밀번호"
        view.font = .systemFont(ofSize: 14, weight: .medium)
        view.backgroundColor = .white
        view.layer.borderWidth = 0.3
        view.tintColor = .point
        return view
    }()
    
    let signInButton = {
        let view = PointButton(title: "로그인하기")
        view.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        return view
    }()
    
    override func configureView() {
        backgroundColor = .white
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(signInButton)
    }
    
    override func configureHierarchy() {
        
        
    }
}
