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
        view.textColor = .black
        view.backgroundColor = .white
        view.layer.borderWidth = 0.3
        view.tintColor = .lightGray
        return view
    }()
    
    let passwordTextField = {
        let view = UITextField()
        view.placeholder = " 비밀번호"
        view.font = .systemFont(ofSize: 14, weight: .medium)
        view.textColor = .black
        view.backgroundColor = .white
        view.layer.borderWidth = 0.3
        view.tintColor = .lightGray
        return view
    }()
    
    let signInButton = {
        let view = PointButton(title: "로그인하기")
        view.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        return view
    }()
    
    let guidanceLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 12, weight: .regular)
        view.textColor = .lightGray
        view.text = "회원 가입하고 더 많은 기능을 써보세요!"
        view.textColor = .point
        return view
    }()
    
    let signUpButton = {
        let view = PointButton(title: "간편 회원가입하기")
        view.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.setTitleColor(.black, for: .normal)
        view.layer.borderWidth = 0.3
        view.tintColor = .lightGray
        view.layer.cornerRadius = 10
        return view
    }()
    
    override func configureView() {
        backgroundColor = .white
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(signInButton)
        addSubview(signUpButton)
        addSubview(guidanceLabel)
    }
    
    override func configureHierarchy() {
        
        
    }
}
