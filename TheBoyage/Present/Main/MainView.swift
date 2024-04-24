//
//  MainView.swift
//  TheBoyage
//
//  Created by Madeline on 4/17/24.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

class MainView: BaseView {
    let scrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.bounces = true
        return view
    }()
    
    let contentView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let magazine = MagazineView()
    let feed = FeedView()
    
    override func configureView() {
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(magazine)
        // TODO: category 추가
        contentView.addSubview(feed)
    }
    
    override func configureHierarchy() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        
        magazine.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height * 0.5)
        }
        
        feed.snp.makeConstraints { make in
            make.top.equalTo(magazine.snp.bottom).offset(36)
//            make.width.equalTo(UIScreen.main.bounds.width * 0.7)
            make.height.equalTo(UIScreen.main.bounds.height * 0.8)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
    }
}
