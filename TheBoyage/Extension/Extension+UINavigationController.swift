//
//  Extension+UINavigationController.swift
//  TheBoyage
//
//  Created by Madeline on 4/15/24.
//

import UIKit

extension UINavigationController {
    open override func viewWillLayoutSubviews() {
        navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
