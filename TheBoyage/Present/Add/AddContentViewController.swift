//
//  AddContentViewController.swift
//  TheBoyage
//
//  Created by Madeline on 4/15/24.
//

import Alamofire
import PhotosUI
import RxCocoa
import RxSwift
import SnapKit
import UIKit

class AddContentViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource  {
    
    let tableView = UITableView()
    var rightButton = UIBarButtonItem()
    var imageArray : [Data] = []
    let viewModel = AddContentViewModel()
    let titleSubject = PublishSubject<String>()
    let contentSubject = PublishSubject<String>()
    let imagesSubject = PublishSubject<[UIImage]>()
    
    private var itemProviders: [NSItemProvider] = []
    private var iterator: IndexingIterator<[NSItemProvider]>?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 5
        configuration.filter = .images
        let phPicker = PHPickerViewController(configuration: configuration)
        phPicker.delegate = self
        if let navigationController = self.navigationController {
            navigationController.present(phPicker, animated: true)
        } else {
            present(phPicker, animated: true)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        configureView()
        
        print("Right button initially set to: \(rightButton.isEnabled)")
        
    }
    
    override func bind() {
        
        titleSubject.subscribe(onNext: {
            print("Title updated: \($0)")
        }).disposed(by: disposeBag)
        
        contentSubject.subscribe(onNext: {
            print("Content updated: \($0)")
        }).disposed(by: disposeBag)
    
        
        let input = AddContentViewModel.Input(
            title: titleSubject.asObservable(),
            content: contentSubject.asObservable(),
            imagesPicked: imagesSubject.asObservable(),
            saveTrigger: rightButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input)
        
        output.isSaveEnabled
            .subscribe(onNext: { [weak self] isEnabled in
                DispatchQueue.main.async {
                    self?.rightButton.isEnabled = isEnabled
                    self?.navigationItem.rightBarButtonItem = self?.rightButton
                    print("Button enabled state now: \(isEnabled)")
                }
            })
            .disposed(by: disposeBag)

        
        output.postResult
            .subscribe(with: self) { owner, isSuccess in
                if isSuccess {
                    print("saved")
                    AlertManager.shared.showOkayAlert(on: self, title: "여행기가 저장 완료", message: "여행기가 저장되었습니다.")
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(8)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .singleLine
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(AddContentTableViewCell.self, forCellReuseIdentifier: "AddContentTableViewCell")
        tableView.register(AddTitleTableViewCell.self, forCellReuseIdentifier: "AddTitleTableViewCell")
        tableView.register(AddImageTableViewCell.self, forCellReuseIdentifier: "AddImageTableViewCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "tagCell")
        
    }
    
    func configureView() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)

        rightButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: nil)
        
        rightButton.tintColor = .lightGray
        // rightButton.isEnabled = false
        
        configureNavigationBar(title: "여행기 작성", rightBarButton: rightButton)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func leftButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    
}

extension AddContentViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: AddImageTableViewCell.identifier, for: indexPath) as! AddImageTableViewCell
            cell.configure(with: imagesSubject)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: AddTitleTableViewCell.identifier, for: indexPath) as! AddTitleTableViewCell
            cell.onTextChanged = { [weak self] text in
                self?.titleSubject.onNext(text)
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: AddContentTableViewCell.identifier, for: indexPath) as! AddContentTableViewCell
            
            cell.onTextChanged = { [weak self] text in
                self?.contentSubject.onNext(text)
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "tagCell", for: indexPath)
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 200
        } else if indexPath.row == 1 {
            return 100
        } else {
            return 300
        }
    }
}

extension AddContentViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        convertPickerResultsToImages(results) { [weak self] images in
            self?.imagesSubject.onNext(images)
        }
        picker.dismiss(animated: true)
    }

    private func convertPickerResultsToImages(_ results: [PHPickerResult], completion: @escaping ([UIImage]) -> Void) {
        var images: [UIImage] = []
        let group = DispatchGroup()
        
        for result in results {
            group.enter()
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                    DispatchQueue.main.async {
                        if let image = image as? UIImage {
                            images.append(image)
                        }
                        group.leave()
                    }
                }
            } else {
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(images)
        }
    }
}
