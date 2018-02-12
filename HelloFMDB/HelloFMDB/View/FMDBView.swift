//
//  FMDBView.swift
//  HelloFMDB
//
//  Created by JOE on 2018/2/12.
//  Copyright © 2018年 Hongyear Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

import UIKit

class FMDBView: UIView {

    ///model
    var model:[Student]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    //MARK: Lazy
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.bounds, style: .plain)
        tableView.separatorStyle = .none
        tableView.rowHeight = 60
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FMDBTableViewCell.self, forCellReuseIdentifier: "FMDBTableViewCellId")
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension FMDBView {
    
    fileprivate func createView() {
        addSubview(tableView)
    }
}

//MARK: UITableViewDelegate, UITableViewDataSource
extension FMDBView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let cnt = self.model?.count {
            return cnt
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = FMDBTableViewCell.createCell(tableView: tableView, atIndexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? FMDBTableViewCell {
            cell.model = self.model?[indexPath.row]
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

//MARK: Private
extension FMDBView {
    
    ///Insert Row
    func insertRow(model: Student) {
        tableView.beginUpdates()
        if self.model != nil {
            self.model?.insert(model, at: 0)
        }else{
            self.model = [model]
        }
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .right)
        tableView.endUpdates()
    }
}












