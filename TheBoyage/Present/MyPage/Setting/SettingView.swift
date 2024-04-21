//
//  SettingView.swift
//  TheBoyage
//
//  Created by Madeline on 4/21/24.
//

import UIKit

class SettingView: BaseView {

    let tableView = UITableView()
    
    override func configureView() {
        addSubview(tableView)
        
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .point
        tableView.separatorInset = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        
    }
    
    override func configureHierarchy() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}
