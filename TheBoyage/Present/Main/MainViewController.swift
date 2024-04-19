//
//  MainViewController.swift
//  TheBoyage
//
//  Created by Madeline on 4/13/24.
//

import UIKit
import SnapKit

class MainViewController: BaseViewController {
    // TODO: Scrollview로 리팩토링
    let mainView = MainView()
    let viewModel = MainViewModel()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        configureNavigation()
        configureTableView()
    }
    
    private func configureView() {
        viewModel.fetchMagazine()
    }
    
    private func configureTableView() {
        
    }
    
    private func configureNavigation() {
        let title = "B O Y A G E"
        navigationController?.title = title
        
        let leftButton = createBarButtonItem(imageName: "bell", action: #selector(leftBarButtonTapped))
        let rightButton = createBarButtonItem(imageName: "magnifyingglass", action: #selector(rightBarButtonTapped))
        configureNavigationBar(title: title, leftBarButton: leftButton, rightBarButton: rightButton)
        
    }
    
    @objc func leftBarButtonTapped() {
        
    }
    
    @objc func rightBarButtonTapped() {
        
    }
}
