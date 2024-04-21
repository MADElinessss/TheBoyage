//
//  MyPageView.swift
//  TheBoyage
//
//  Created by Madeline on 4/15/24.
//

import SnapKit
import UIKit

class MyPageView: BaseView {
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
    
    let profile = ProfileView()
    let myFeed = MyFeedView()
    
    override func configureView() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(profile)
        contentView.addSubview(myFeed)
        
        profile.backgroundColor = .black
    }
    
    override func configureHierarchy() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        
        profile.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height * 0.25)
        }
        
        myFeed.snp.makeConstraints { make in
            make.top.equalTo(profile.snp.bottom)
            make.width.equalTo(UIScreen.main.bounds.width * 0.9)
            make.height.equalTo(UIScreen.main.bounds.height * 0.5)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
}
