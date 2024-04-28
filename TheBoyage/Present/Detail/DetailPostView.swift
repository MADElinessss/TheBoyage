//
//  DetailPostView.swift
//  TheBoyage
//
//  Created by Madeline on 4/25/24.
//

import UIKit
import SnapKit
import RxCocoa
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
    
    let likeCount: UILabel = {
        let view = UILabel()
        view.text = "0"
        view.font = .systemFont(ofSize: 13, weight: .medium)
        view.textColor = .point
        return view
    }()
    
    let commentButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "bubble.left"), for: .normal)
        button.tintColor = .point
        return button
    }()
    
    let commentCount: UILabel = {
        let view = UILabel()
        view.text = "0"
        view.font = .systemFont(ofSize: 13, weight: .medium)
        view.textColor = .point
        return view
    }()
    
    let shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.tintColor = .point
        return button
    }()
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = " 댓글을 입력하세요..."
        textField.returnKeyType = .done
        textField.borderStyle = .roundedRect
        return textField
    }()
    let actionButton = UIButton(type: .custom)
    
    let viewModel = DetailViewModel()

    override func configureView() {
        
        addSubview(collectionView)
        addSubview(toolbar)
        addSubview(textField)
        
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
    
        // MARK: ToolBar Related
        
        configureTextField()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let likeItem = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(likeButtonTapped))
        let commentItem = UIBarButtonItem(image: UIImage(systemName: "bubble.left"), style: .plain, target: self, action: #selector(commentButtonTapped))
        let shareItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonTapped))

        let likeCountItem = UIBarButtonItem(customView: likeCount)
        let commentCountItem = UIBarButtonItem(customView: commentCount)
        
        let paddingItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        paddingItem.width = 8
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([likeItem, likeCountItem, paddingItem, commentItem, commentCountItem, flexSpace, flexSpace, shareItem], animated: false)
        
    }
    
    func bind(post: Posts) {
        likeCount.text = "\(post.likes.count)"
        commentCount.text = "\(post.comments.count)"
        
        let commentTextObservable = textField.rx.text.orEmpty.asObservable()
        let input = DetailViewModel.Input(
            post: post, // 여기서 `post`는 해당 뷰모델에 전달되어야 하는 현재 게시물 객체입니다.
            likeButtonPressed: likeButton.rx.tap.asObservable(),
            commentText: commentTextObservable
        )
        
        let output = viewModel.transform(input)
        
        actionButton.rx.tap
            .withLatestFrom(commentTextObservable)
            .subscribe(onNext: { [weak self] commentText in
                guard let self = self else { return }
                self.viewModel.commentSubmitted.onNext((post.post_id, commentText))
                self.viewModel.postComment()
            })
            .disposed(by: disposeBag)
        
    }
    
    
    private func configureTextField() {

        textField.isHidden = true
        textField.delegate = self
        
        actionButton.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        actionButton.tintColor = .point
        actionButton.addTarget(self, action: #selector(sendComment), for: .touchUpInside)
        
        let buttonContainer = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        actionButton.frame = CGRect(x: 10, y: 0, width: 30, height: 30)
        
        buttonContainer.addSubview(actionButton)
        
        textField.rightView = buttonContainer
        textField.rightViewMode = .always
    }
    
    @objc func sendComment() {
        // 댓글 전송 로직
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
    
    @objc private func shareButtonTapped() {
        // TODO: 공유 기능
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
