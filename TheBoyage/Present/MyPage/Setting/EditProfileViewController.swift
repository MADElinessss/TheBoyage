//
//  EditProfileViewController.swift
//  TheBoyage
//
//  Created by Madeline on 4/21/24.
//

import SnapKit
import UIKit
import PhotosUI
import RxCocoa
import RxSwift

class EditProfileViewController: BaseViewController {
    
    let mainView = EditProfileView()
    let viewModel = EditProfileViewModel()
    
    private let imageSelectedSubject = PublishSubject<UIImage>()
    private let viewLoadedSubject = PublishSubject<Void>()
    
    private let nameSubject = BehaviorSubject<String>(value: "")
    private let phoneNumberSubject = BehaviorSubject<String>(value: "")
    private let birthDateSubject = BehaviorSubject<Date>(value: Date())
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewLoadedSubject.onNext(())
        
        configureView()
        configureNavigation()
    }
    
    private func configureView() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.register(ProfileImageCell.self, forCellReuseIdentifier: ProfileImageCell.identifier)
        mainView.tableView.register(EditableTextCell.self, forCellReuseIdentifier: EditableTextCell.identifier)
        mainView.tableView.register(DatePickerCell.self, forCellReuseIdentifier: DatePickerCell.identifier)
        
    }
    
    private func configureNavigation() {
        configureNavigationBar(title: "EDIT PROFILE", leftBarButton: nil, rightBarButton: nil)
    }
    
    override func bind() {
        
        if let nameCell = mainView.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? EditableTextCell {
            nameCell.textField.rx.text.orEmpty
                .bind(to: nameSubject)
                .disposed(by: disposeBag)
        }
        
        if let phoneCell = mainView.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? EditableTextCell {
            phoneCell.textField.rx.text.orEmpty
                .bind(to: phoneNumberSubject)
                .disposed(by: disposeBag)
        }
        
        if let dateCell = mainView.tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as? DatePickerCell {
            dateCell.datePicker.rx.date
                .bind(to: birthDateSubject)
                .disposed(by: disposeBag)
        }
        
        // ViewModel binding
        let input = EditProfileViewModel.Input(
            viewLoaded: viewLoadedSubject,
            imageSelected: imageSelectedSubject,
            saveButtonTapped: mainView.updateButton.rx.tap,
            withdrawTrigger: mainView.withdrawButton.rx.tap,
            name: nameSubject.asObservable(),
            phoneNumber: phoneNumberSubject.asObservable(),
            birthDate: birthDateSubject.asObservable()
        )

        
        let output = viewModel.transform(input)
        
        output.profileData
            .drive(onNext: { [weak self] (profile: MyProfileModel?) in
                guard let profile = profile, let self = self else { return }
                
                self.updateProfileImageCell(with: profile.profileImage)
                if let nameCell = self.mainView.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? EditableTextCell {
                    nameCell.textField.text = profile.nick
                }
                if let phoneCell = self.mainView.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? EditableTextCell {
                    phoneCell.textField.text = profile.phoneNum
                }
                if let dateCell = self.mainView.tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as? DatePickerCell {
                    if let date = profile.birthDay {
                        let birthday = FormatterManager.shared.formatStringToDate(date)
                        dateCell.datePicker.setDate(birthday, animated: true)
                    }
                }
            })
            .disposed(by: viewModel.disposeBag)
        
        viewModel.uploadResultSubject
            .subscribe(onNext: { [weak self] success in
                if success {
                    self?.navigationController?.popViewController(animated: true)
                } else {
                    AlertManager.shared.showOkayAlert(on: self!, title: "프로필 업데이트", message: "업데이트에 실패하였습니다.\n다시 시도해주세요.")
                }
            })
            .disposed(by: disposeBag)
      
        output.withdrawalResult
            .drive(onNext: { [weak self] (success: Bool) in
                if success {
                    // 탈퇴 성공 알림 표시
                    AlertManager.shared.showOkayAlert(on: self!, title: "회원탈퇴하기", message: "성공적으로 탈퇴하였습니다.")
                } else {
                    // 탈퇴 실패 알림 표시
                    AlertManager.shared.showOkayAlert(on: self!, title: "회원탈퇴하기", message: "회원 탈되에 실패하였습니다.\n문제가 지속된다면 지원팀에 문의주세요.")
                }
            })
            .disposed(by: viewModel.disposeBag)
    
        
        mainView.withdrawButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.confirmWithdrawal()
            })
            .disposed(by: disposeBag)
    }
    
    func updateProfileImageCell(with imageName: String?) {
        guard let imageName = imageName else {
            // 기본 이미지 설정
            let defaultImage = UIImage(systemName: "person.fill")
            setImageToCell(image: defaultImage)
            return
        }
        
        viewModel.loadImage(from: imageName)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] image in
                self?.setImageToCell(image: image)
            }, onError: { error in
                // 에러 처리: 로딩 실패 시 기본 이미지 사용
                let defaultImage = UIImage(systemName: "person.fill")
                self.setImageToCell(image: defaultImage)
            })
            .disposed(by: disposeBag)
    }
    
    func setImageToCell(image: UIImage?) {
        guard let image = image, let cell = mainView.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ProfileImageCell else { return }
        cell.setImage(image)
    }
    
    private func confirmWithdrawal() {
        let alert = UIAlertController(title: "회원 탈퇴", message: "진짜로 탈퇴하시겠습니까?🥹", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "확인", style: .destructive, handler: { [weak self] _ in
            self?.viewModel.withdraw()
            self?.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true)
    }
}

extension EditProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileImageCell", for: indexPath) as! ProfileImageCell
            cell.configure()
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditableTextCell", for: indexPath) as! EditableTextCell
            cell.configure(placeholder: "이름")
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditableTextCell", for: indexPath) as! EditableTextCell
            cell.configure(placeholder: "전화번호")
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DatePickerCell", for: indexPath) as! DatePickerCell
            cell.configure()
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            presentPhotoPicker()
        } else {
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 150
        } else {
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 44))
        
        let headerLabel = UILabel()
        headerLabel.text = "회원 정보"
        headerLabel.font = .systemFont(ofSize: 20, weight: .bold)
        headerLabel.textColor = .black
        
        let thickSeparator = UIView()
        thickSeparator.backgroundColor = .black
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

extension EditProfileViewController: PHPickerViewControllerDelegate {
    func presentPhotoPicker() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let result = results.first, result.itemProvider.canLoadObject(ofClass: UIImage.self) else {
            return
        }
        
        result.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
            
            guard let image = image as? UIImage, let data = image.jpegData(compressionQuality: 0.8) else { return }
            
            DispatchQueue.main.async {
                self.imageSelectedSubject.onNext(image)
            }
        }
    }
}


extension EditProfileViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}
