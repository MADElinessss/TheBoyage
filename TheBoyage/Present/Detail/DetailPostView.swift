//
//  DetailPostView.swift
//  TheBoyage
//
//  Created by Madeline on 4/25/24.
//

import UIKit
import SnapKit
import RxSwift

class DetailPostView: BaseView, UITextFieldDelegate {

    var disposeBag = DisposeBag()
    
    let collectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
        collectionView.showsHorizontalScrollIndicator = true
        return collectionView
    }()
    
    let toolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        return toolbar
    }()
    
    let likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .point
        return button
    }()
    
    let commentButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "bubble.left"), for: .normal)
        button.tintColor = .point
        return button
    }()
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "댓글을 입력하세요..."
        textField.returnKeyType = .done
        textField.borderStyle = .roundedRect
        return textField
    }()

    override func configureView() {
        
        addSubview(collectionView)
        addSubview(toolbar)
        addSubview(textField)
        
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        
        let likeItem = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(likeButtonTapped))
        let commentItem = UIBarButtonItem(image: UIImage(systemName: "bubble.left"), style: .plain, target: self, action: #selector(commentButtonTapped))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([flexSpace, likeItem, flexSpace, commentItem, flexSpace], animated: false)
        
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        
        // MARK: Comment Related
        textField.isHidden = true
        textField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc private func likeButtonTapped() {
        likeButton.isSelected.toggle()
        let imageName = likeButton.isSelected ? "heart.fill" : "heart" 
        likeButton.setImage(UIImage(systemName: imageName), for: .normal)
    }

    @objc private func commentButtonTapped() {
        textField.isHidden = false
        textField.becomeFirstResponder()
    }
    
    override func configureHierarchy() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        toolbar.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.3) {
                self.toolbar.snp.remakeConstraints { make in
                    make.left.right.equalToSuperview()
                    make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).inset(keyboardSize.height + 16)
                    make.height.equalTo(50)
                }
                self.textField.snp.remakeConstraints { make in
                    make.left.right.equalToSuperview()
                    make.top.equalTo(self.toolbar.snp.bottom)
                    make.height.equalTo(50)
                }
                self.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.toolbar.snp.remakeConstraints { make in
                make.left.right.equalToSuperview()
                make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).inset(16)
                make.height.equalTo(50)
            }
            self.textField.isHidden = true
            self.layoutIfNeeded()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    static func layout() -> UICollectionViewFlowLayout {
        
        let layout = UICollectionViewFlowLayout()
        
        let width = (UIScreen.main.bounds.width - 36)
        layout.itemSize = CGSize(width: width, height: width*1.5)
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: 16, right: 0)
        layout.scrollDirection = .vertical
        
        return layout
    }

}
