//
//  CommentViewController.swift
//  TheBoyage
//
//  Created by Madeline on 4/28/24.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class CommentViewController: BaseViewController, UITextFieldDelegate, UITableViewDataSource {
    
    var comments: [CommentModel] = []
    
    private let tableView = UITableView()
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = " 댓글을 입력하세요..."
        textField.returnKeyType = .done
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let actionButton = UIButton(type: .custom)
    
    var viewModel = CommentViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupKeyboardNotifications()
        textField.becomeFirstResponder()
        tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: "CommentCell")
        
    }
    
    override func bind() {
        let input = CommentViewModel.Input(
            commentText: textField.rx.text.orEmpty.asObservable(),
            submitComment: actionButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input)
        
        output.result
            .subscribe(onNext: { result in
                print(result) // 결과 로깅
            })
            .disposed(by: disposeBag)
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        view.addSubview(textField)
        
        tableView.dataSource = self
        
        configureTextField()
    }
    
    private func setupConstraints() {
        textField.snp.makeConstraints { make in
            make.left.right.equalTo(view.safeAreaLayoutGuide).inset(10)
            //make.bottom.equalTo(view.safeAreaLayoutGuide).inset(200)
            make.height.equalTo(50)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(textField.snp.top).offset(-10)
        }
    }
    
    //    override func bind() {
    //
    //        let commentTextObservable = textField.rx.text.orEmpty.asObservable()
    //
    //        actionButton.rx.tap
    //            .withLatestFrom(commentTextObservable)
    //            .subscribe(onNext: { [weak self] commentText in
    //                guard let self = self else { return }
    //                self.viewModel.commentSubmitted.onNext((post.post_id, commentText))
    //                self.viewModel.postComment()
    //                textField.resignFirstResponder()
    //            })
    //            .disposed(by: disposeBag)
    //    }
    
    private func configureTextField() {
        
        textField.isHidden = true
        textField.delegate = self
        textField.borderStyle = .roundedRect
        
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
        textField.resignFirstResponder()
    }
    
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            textField.snp.remakeConstraints { make in
                make.bottom.equalToSuperview().inset(keyboardSize.height + 10)
                make.left.right.equalTo(view.safeAreaLayoutGuide).inset(10)
                make.height.equalTo(50)
            }
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        textField.snp.remakeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension CommentViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as? CommentTableViewCell else {
            return UITableViewCell()
        }
        
        let comment = comments[indexPath.row]
        cell.configure(with: comment)
        return cell
    }
}
