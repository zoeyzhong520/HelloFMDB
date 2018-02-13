//
//  FMDBDetailViewController.swift
//  HelloFMDB
//
//  Created by JOE on 2018/2/13.
//  Copyright © 2018年 Hongyear Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

import UIKit

class FMDBDetailViewController: BaseViewController {

    ///indicatorView
    lazy var indicatorView: UILabel = {
        let indicatorView = UILabel(frame: CGRect(x: 0, y: self.view.bounds.size.height / 2 - 60, width: self.view.bounds.size.width, height: 60))
        indicatorView.textColor = UIColor.white
        indicatorView.text = self.title
        indicatorView.textAlignment = .center
        return indicatorView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension FMDBDetailViewController {
    
    //MARK: - UI
    fileprivate func setPage() {
        //indicatorView
        view.addSubview(indicatorView)
    }
}



















