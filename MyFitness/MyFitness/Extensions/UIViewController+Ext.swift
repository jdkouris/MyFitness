//
//  UIViewController+Ext.swift
//  MyFitness
//
//  Created by John Kouris on 12/4/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentMFAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = MFAlertVC(title: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
}
