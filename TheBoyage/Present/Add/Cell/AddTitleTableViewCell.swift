//
//  AddTitleTableViewCell.swift
//  TheBoyage
//
//  Created by Madeline on 4/15/24.
//

import SnapKit
import UIKit

final class AddTitleTableViewCell: BaseTableViewCell {
    
    let textViewPlaceHolder = "당신의 여행에 제목을 붙여주세요."
    
    lazy var textView: UITextView = {
        let view = UITextView()
        view.font = .systemFont(ofSize: 16)
        view.text = textViewPlaceHolder
        view.textColor = .lightGray
        view.delegate = self

        return view
    }()
    
    let remainCountLabel = UILabel()
    let titleLabel = UILabel()
    
    var onTextChanged: ((String) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureView()
        
        updateCountLabel(characterCount: textView.text.count)
    }
    
    private func configureView() {
        
        contentView.backgroundColor = .white
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(textView)
        contentView.addSubview(remainCountLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(18)
        }
        
        textView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
        }
        
        remainCountLabel.snp.makeConstraints { make in
            make.bottom.equalTo(textView.snp.bottom)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(16)
        }
        
        titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        titleLabel.text = "제목"
        titleLabel.textColor = .black
       
        remainCountLabel.text = "0/50"
        remainCountLabel.font = .systemFont(ofSize: 14)
        remainCountLabel.textColor = .lightGray
        
    }
    
    private func updateCountLabel(characterCount: Int) {
        if textView.textColor == .lightGray {
            remainCountLabel.text = "0/50"
        } else {
            remainCountLabel.text = "\(characterCount)/50"
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AddTitleTableViewCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = .lightGray
            remainCountLabel.text = "0/50"
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        onTextChanged?(textView.text)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let inputString = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let oldString = textView.text, let newRange = Range(range, in: oldString) else { return true }
        let newString = oldString.replacingCharacters(in: newRange, with: inputString).trimmingCharacters(in: .whitespacesAndNewlines)
        
        let characterCount = newString.count
        guard characterCount <= 50 else { return false }
        updateCountLabel(characterCount: characterCount)
        
        return true
    }
}
