//
//  BaseViewController.swift
//  TheBoyage
//
//  Created by Madeline on 4/11/24.
//

import RxCocoa
import RxSwift
import UIKit

class BaseViewController: UIViewController {
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        bind()
    }
    
    func bind() { }
    
    func configureNavigationBar(title: String, rightBarButton: UIBarButtonItem? = nil) {
        self.navigationItem.title = title
        
        if let rightButton = rightBarButton {
            self.navigationItem.rightBarButtonItem = rightButton
        }
    }
    
    func createBarButtonItem(imageName: String, action: Selector) -> UIBarButtonItem {
        let barButtonItem = UIBarButtonItem(image: UIImage(systemName: imageName), style: .plain, target: self, action: action)
        barButtonItem.tintColor = .point
        return barButtonItem
    }
}
