//
//  AlertManager.swift
//  TheBoyage
//
//  Created by Madeline on 4/17/24.
//

import Foundation
import UIKit

class AlertManager {
    static let shared = AlertManager()
    
    private init() { }
    
    func showOkayAlert(
        on viewController: UIViewController,
        title: String,
        message: String
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default)
        alert.addAction(ok)
        
        DispatchQueue.main.async {
            viewController.present(viewController, animated: true)
        }
    }
}
