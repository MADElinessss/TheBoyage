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
    
    private var itemProviders: [NSItemProvider] = []
    private var iterator: IndexingIterator<[NSItemProvider]>?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 5
        configuration.filter = .images
        let phPicker = PHPickerViewController(configuration: configuration)
        phPicker.delegate = self
        present(phPicker, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        configureView()
        
    }
    
    private func setupTableView() {
        
        //        view.backgroundColor = .lightGray
        //        tableView.backgroundColor = .lightGray
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(8)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //tableView.separatorStyle = .none
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
        
        let leftButton = createBarButtonItem(imageName: "chevron.left", action: #selector(leftButtonTapped))
        rightButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(rightButtonTapped))
        
        rightButton.tintColor = .lightGray
        rightButton.isEnabled = false
        
        configureNavigationBar(title: "여행기 작성", rightBarButton: rightButton)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func leftButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func rightButtonTapped() {
        // TODO: 글 POST
        navigationController?.popViewController(animated: true)
    }
    
    
}

extension AddContentViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: AddImageTableViewCell.identifier, for: indexPath) as! AddImageTableViewCell
            
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: AddTitleTableViewCell.identifier, for: indexPath) as! AddTitleTableViewCell
            
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: AddContentTableViewCell.identifier, for: indexPath) as! AddContentTableViewCell
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "tagCell", for: indexPath)
            cell.textLabel?.text = "관련 주제 태그하기"
            cell.layer.cornerRadius = 15
            cell.selectionStyle = .none
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
        } else if indexPath.row == 2 {
            return 300
        } else {
            return 44
        }
    }
}

extension AddContentViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        itemProviders = results.map(\.itemProvider)
        var loadedImages = 0
        var imageUrls: [String] = []
        
        for item in itemProviders {
            if item.canLoadObject(ofClass: UIImage.self) {
                item.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    DispatchQueue.main.async {
                        guard let self = self else { return }
                        if let error = error {
                            print("Error loading image: \(error)")
                            return
                        }
                        guard let image = image as? UIImage, let imageData = image.jpegData(compressionQuality: 0.8) else {
                            print("Failed to convert image to JPEG")
                            return
                        }
                        let imageQuery = ImageUploadQuery(files: imageData)
                        print("44", imageQuery)
                        PostNetworkManager.imageUpload(query: imageQuery)
                            .asObservable()
                            .subscribe(with: self) { owner, image in
                                if let image = image.files {
                                    self.postContent(files: image)
                                } else {
                                    // TODO: 이미지 불러오는데 실패함 알럿
                                    print("view - 실팬가?")
                                }
                            }
                            .disposed(by: self.disposeBag)
                    }
                }
            }
        }
        picker.dismiss(animated: true)
    }
    
    private func showAlertWithMessage(_ message: String) {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        self.present(alert, animated: true)
    }
    
    
    
    func postContent(files: [String]) {
        let query = PostQuery(title: "Test", content: "Content", content1: "Content1", product_id: "lslp", files: files)
        PostNetworkManager.postContent(query: query)
            .asObservable()
            .subscribe(with: self) { owner, response in
                print(response)
            }
            .disposed(by: disposeBag)
    }
}
