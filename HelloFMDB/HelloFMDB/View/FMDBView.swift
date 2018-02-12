//
//  FMDBView.swift
//  HelloFMDB
//
//  Created by JOE on 2018/2/12.
//  Copyright © 2018年 Hongyear Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

import UIKit

class FMDBView: UIView {

    ///添加的姓名
    var insertName = "小白"
    
    ///添加的性别
    var insertSex = "男"
    
    ///添加的年龄
    var insertAge = 12
    
    ///model
    var model:[Student]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    //MARK: Lazy
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.bounds, style: .plain)
        tableView.allowsMultipleSelectionDuringEditing = true //开启多选
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
//        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            if let studentID = self.model?[indexPath.row].studentID {
                FMDBHelper.shareInstance.deleteByIDQueue(studentID: studentID)
            }
            self.model?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .right)
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.init(rawValue: UITableViewCellEditingStyle.delete.rawValue | UITableViewCellEditingStyle.insert.rawValue)!
    }
}

//MARK: Private
extension FMDBView {
    
    ///Insert Row
    func insertRow() {
        tableView.beginUpdates()
        
        let insertID = Int(arc4random() % 1000)
        print("insertID: \(insertID)")
        
        if FMDBHelper.shareInstance.selectByConditionQueue(condition: "select * from t_student where studentID = ?;", studentId: insertID) == nil {
            
            FMDBHelper.shareInstance.insertQueue(studentID: insertID, name: insertName, sex: insertSex, age: insertAge)
        }
        
        let insertModel = Student.create(studentID: insertID, name: insertName, sex: insertSex, age: insertAge)
        if self.model != nil {
            self.model?.insert(insertModel, at: 0)
        }else{
            self.model = [insertModel]
        }
        
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .left)
        
        tableView.endUpdates()
        
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true) //滚动到顶部
    }
}












