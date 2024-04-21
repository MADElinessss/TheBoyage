//
//  SettingViewController.swift
//  TheBoyage
//
//  Created by Madeline on 4/21/24.
//

import SnapKit
import UIKit

class SettingViewController: BaseViewController {
    
    let mainView = SettingView()

    let tableViewTitles = ["프로필 편집", "탈퇴"]
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        configureNavigation()
    }
    
    private func configureView() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func configureNavigation() {
        let rightButton = createBarButtonItem(imageName: "xmark", action: #selector(rightBarButtonTapped))
        
        configureNavigationBar(title: "SETTINGS", leftBarButton: nil, rightBarButton: rightButton)
    }
    
    @objc func rightBarButtonTapped() {
        dismiss(animated: true)
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = tableViewTitles[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
        } else {
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 44))
        
        let headerLabel = UILabel()
        headerLabel.text = "나의 계정 정보"
        headerLabel.font = .systemFont(ofSize: 24, weight: .bold)
        headerLabel.textColor = .black
        
        let thickSeparator = UIView()
        thickSeparator.backgroundColor = .black
        headerView.addSubview(thickSeparator)
        headerView.addSubview(headerLabel)
        
        headerLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.left.right.equalToSuperview().inset(16)
        }
        
        thickSeparator.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(3)
            make.bottom.equalToSuperview()
        }
        
        return headerView
    }
}
