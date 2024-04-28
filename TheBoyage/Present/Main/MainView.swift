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
        view.showsVerticalScrollIndicator = false
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
    let hashTag = HashTagView()
    
    override func configureView() {
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(magazine)
        contentView.addSubview(hashTag)
        contentView.addSubview(feed)
    }
    
    override func configureHierarchy() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
            make.bottom.equalTo(feed.snp.bottom)
        }
        
        magazine.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height * 0.5)
        }
        
        hashTag.snp.makeConstraints { make in
            make.top.equalTo(magazine.snp.bottom)
            make.height.equalTo(100)
            make.horizontalEdges.equalToSuperview()
        }
        
        feed.snp.makeConstraints { make in
            make.top.equalTo(hashTag.snp.bottom).offset(8)
            make.height.equalTo(UIScreen.main.bounds.height * 0.8)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
    }
}
