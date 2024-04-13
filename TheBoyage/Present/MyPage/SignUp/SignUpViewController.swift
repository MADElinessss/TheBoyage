//
//  SignUpViewController.swift
//  TheBoyage
//
//  Created by Madeline on 4/12/24.
//

import RxCocoa
import RxSwift
import UIKit

class SignUpViewController: BaseViewController {
    var currentPage: Int = 0
    let pages: [UIViewController] = [EmailViewController(), PasswordViewController(), EtcViewController()]
    let progressView = ProgressView(numberOfSteps: 3)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupProgressView()
        
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: progressView.frame.maxY, width: view.bounds.width, height: view.bounds.height - progressView.frame.maxY)
        view.addSubview(containerView)

        // 첫 번째 페이지 로드
        addChild(pages[0])
        containerView.addSubview(pages[0].view)
        pages[0].view.frame = containerView.bounds
        pages[0].didMove(toParent: self)
    }

    func setupProgressView() {
        view.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(4)
            make.width.equalToSuperview().multipliedBy(0.9)
        }
        progressView.updateProgress(currentStep: 0)
    }

    func showNextPage(currentIndex: Int) {
        let nextIndex = currentIndex + 1
        guard nextIndex < pages.count else { return }

        let currentVC = pages[currentIndex]
        let nextVC = pages[nextIndex]

//        currentVC.willMove(toParent: nil)
//        addChild(nextVC)
        
        addChild(nextVC)
        nextVC.view.frame = view.bounds
        
        transition(from: currentVC, to: nextVC, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.progressView.updateProgress(currentStep: nextIndex)
        }) { completed in
            currentVC.removeFromParent()
            nextVC.didMove(toParent: self)
            self.currentPage = nextIndex
        }
    }
}
