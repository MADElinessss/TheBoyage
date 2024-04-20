//
//  ProgressView.swift
//  TheBoyage
//
//  Created by Madeline on 4/13/24.
//

import UIKit
import SnapKit

class ProgressView: UIView {
    private var indicators: [UIView] = []
    private let numberOfSteps: Int

    init(numberOfSteps: Int) {
        self.numberOfSteps = numberOfSteps
        super.init(frame: .zero)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        stackView.axis = .horizontal

        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        for _ in 0..<numberOfSteps {
            let view = UIView()
            view.backgroundColor = .lightGray
            indicators.append(view)
            stackView.addArrangedSubview(view)
        }
    }

    func updateProgress(currentStep: Int) {
        indicators.enumerated().forEach { index, view in
            view.backgroundColor = index < currentStep ? .point : .lightGray
        }
    }
}
