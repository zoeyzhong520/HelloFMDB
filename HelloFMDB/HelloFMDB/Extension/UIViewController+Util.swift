//
//  UIViewController+Util.swift
//  HelloFMDB
//
//  Created by JOE on 2018/2/12.
//  Copyright © 2018年 Hongyear Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

import UIKit

extension UIViewController {
    
    //MARK: - Set Alert
    ///Set Alert
    func alert(title: String?, message: String?) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in
            
        }))
        self.present(alertView, animated: true, completion: nil)
    }
    
    ///Alert with action
    func alert(title: String?, message: String?, completion: @escaping (() -> Void)) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "取消", style: .default, handler: { (action) in
            
        }))
        alertView.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in
            completion()
        }))
        self.present(alertView, animated: true, completion: nil)
    }
    
    ///Alert with disAppear
    func alert(title: String?, message: String?, duration: TimeInterval = 2.0) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alertView, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
            alertView.dismiss(animated: true, completion: nil)
        }
    }
}











