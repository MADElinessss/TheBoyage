//
//  SettingViewController.swift
//  TheBoyage
//
//  Created by Madeline on 4/21/24.
//

import SnapKit
import UIKit

enum SettingSection: Int, CaseIterable {
    case accountInfo
    case permissions
    case customerService

    var headerTitle: String {
        switch self {
        case .accountInfo: return "나의 계정 정보"
        case .permissions: return "권한 설정"
        case .customerService: return "고객센터"
        }
    }

    var rows: [String] {
        switch self {
        case .accountInfo: return ["프로필 편집", "탈퇴"]
        case .permissions: return ["알림 설정", "이미지 캐시 삭제"]
        case .customerService: return ["FAQ", "고객의 소리", "공지사항", "BOYAGER 소개"]
        }
    }
}


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
        guard let section = SettingSection(rawValue: section) else { return 0 }
        return section.rows.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let section = SettingSection(rawValue: indexPath.section) {
            cell.textLabel?.text = section.rows[indexPath.row]
        }
        //cell.textLabel?.text = tableViewTitles[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc = EditProfileViewController()
            navigationController?.pushViewController(vc, animated: true)
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
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 54))
        
        let headerLabel = UILabel()
        headerLabel.font = .systemFont(ofSize: 20, weight: .bold)
        headerLabel.textColor = .black
        guard let section = SettingSection(rawValue: section) else { return nil }
        headerLabel.text = section.headerTitle
        
        let thickSeparator = UIView()
        thickSeparator.backgroundColor = .black
        thickSeparator.tintColor = .black
        headerView.addSubview(thickSeparator)
        headerView.addSubview(headerLabel)
        
        headerLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.left.right.equalToSuperview().inset(16)
        }
        
        thickSeparator.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(4)
            make.height.equalTo(10)
            make.bottom.equalToSuperview()
        }
        
        return headerView
    }
}
