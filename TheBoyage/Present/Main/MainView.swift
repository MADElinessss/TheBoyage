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
        // category
        contentView.addSubview(feed)
        
        contentView.backgroundColor = .green
        magazine.backgroundColor = .blue
        feed.backgroundColor = .red
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
            make.top.equalTo(magazine.snp.bottom)
            make.width.equalTo(UIScreen.main.bounds.width * 0.9)
            make.height.equalTo(UIScreen.main.bounds.height * 0.5)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
    }
    
}
