//
//  BaseView.swift
//  TheBoyage
//
//  Created by Madeline on 4/11/24.
//

import UIKit

class BaseView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        configureView()
        configureHierarchy()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() { 
        
    }
    
    func configureHierarchy() { }
}
