//
//  AddContentViewController.swift
//  TheBoyage
//
//  Created by Madeline on 4/15/24.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

class AddContentViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource  {

    let tableView = UITableView()
    var rightButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        configureView()
        
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(8)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(AddContentTableViewCell.self, forCellReuseIdentifier: "AddContentTableViewCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AddLottoTableViewCell")
        
    }
    
    func configureView() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        let leftButton = createBarButtonItem(imageName: "chevron.left", action: #selector(leftButtonTapped))
        rightButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(rightButtonTapped))
        
        rightButton.tintColor = .lightGray
        rightButton.isEnabled = false
        
        configureNavigationBar(title: "일기 작성", rightBarButton: rightButton)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func leftButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func rightButtonTapped() {
        // TODO: 글 POST
        navigationController?.popViewController(animated: true)
    }

   
}

extension AddContentViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: AddImageTableViewCell.identifier, for: indexPath) as! AddImageTableViewCell
            
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: AddTitleTableViewCell.identifier, for: indexPath) as! AddTitleTableViewCell
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: AddContentTableViewCell.identifier, for: indexPath) as! AddContentTableViewCell
            
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
}
