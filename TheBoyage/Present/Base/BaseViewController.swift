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
}
