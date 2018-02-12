//
//  FMDBViewController.swift
//  HelloFMDB
//
//  Created by JOE on 2018/2/12.
//  Copyright © 2018年 Hongyear Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

import UIKit

class FMDBViewController: BaseViewController {

    //MARK: Lazy
    lazy var fmdbView: FMDBView = {
        let fmdbView = FMDBView(frame: CGRect(x: 0, y: statusBarHeight + navigationBarHeight, width: self.view.bounds.size.width, height: self.view.bounds.size.height - CGFloat(60) - statusBarHeight - navigationBarHeight))
        return fmdbView
    }()
    
    ///添加的ID
    var insertID = 0
    
    ///添加的姓名
    var insertName = "小白"
    
    ///添加的性别
    var insertSex = "男"
    
    ///添加的年龄
    var insertAge = 12
    
    ///删除的名字
    var deleteName = "小白"
    
    ///createDBBtn
    var createDBBtn:UIButton!
    
    ///isDBOpened
    var isDBOpened:Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPage()
        getData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //关闭数据库
        FMDBHelper.shareInstance.closeDBQueue()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension FMDBViewController {
    
    ///Set page
    fileprivate func setPage() {
        //设置导航栏
        self.title = "FMDB"
        isDBOpened = false
        view.backgroundColor = RGB(244, 244, 244)
        
        //FMDBView
        view.addSubview(fmdbView)
        
        let leftBarBtn = UIButton(type: .system)
        leftBarBtn.setTitle("编辑", for: .normal)
        leftBarBtn.addTarget(self, action: #selector(leftBarBtnAction(btn:)), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarBtn)
        
        let rightBarBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightBarBtnAction))
        self.navigationItem.rightBarButtonItem = rightBarBtn
        
        //创建数据库
        let createDBBtn = UIButton(type: .system)
        createDBBtn.setTitleColor(UIColor.gray, for: .normal)
        createDBBtn.backgroundColor = RGB(244, 244, 244)
        createDBBtn.frame = CGRect(x: 0, y: view.bounds.size.height - 60, width: screenWidth / 3, height: 60)
        createDBBtn.setTitle("打开数据库", for: .normal)
        createDBBtn.addTarget(self, action: #selector(createDBBtnAction(btn:)), for: .touchUpInside)
        view.addSubview(createDBBtn)
        self.createDBBtn = createDBBtn
        
        //查询按钮
        let selectBtn = UIButton(type: .system)
        selectBtn.backgroundColor = RGB(244, 244, 244)
        selectBtn.frame = CGRect(x: createDBBtn.frame.maxX, y: view.bounds.size.height - 60, width: screenWidth / 3, height: 60)
        selectBtn.setTitle("查询数据库", for: .normal)
        selectBtn.addTarget(self, action: #selector(selectBtnAction), for: .touchUpInside)
        view.addSubview(selectBtn)
        
        //删除按钮
        let deleteBtn = UIButton(type: .system)
        deleteBtn.backgroundColor = RGB(244, 244, 244)
        deleteBtn.frame = CGRect(x: selectBtn.frame.maxX, y: view.bounds.size.height - 60, width: screenWidth / 3, height: 60)
        deleteBtn.setTitle("删除数据库", for: .normal)
        deleteBtn.addTarget(self, action: #selector(deleteBtnAction), for: .touchUpInside)
        view.addSubview(deleteBtn)
    }
    
    ///Get Data
    fileprivate func getData() {
        if fmdbView.model == nil {
            isDBOpened = true
            FMDBHelper.shareInstance.openDBQueue()
            createDBBtn.setTitleColor(RGB(28, 127, 253), for: .normal)
            createDBBtn.setTitle("关闭数据库", for: .normal)
            
            let model = FMDBHelper.shareInstance.selectAllQueue()
            fmdbView.model = model
        }
    }
    
    //MARK: - 点击按钮的Action
    @objc fileprivate func leftBarBtnAction(btn: UIButton) {
        //编辑数据
        if fmdbView.tableView.isEditing == true {
            btn.setTitle("编辑", for: .normal)
            fmdbView.tableView.setEditing(false, animated: true)
        }else{
            btn.setTitle("取消", for: .normal)
            fmdbView.tableView.setEditing(true, animated: true)
        }
    }
    
    @objc fileprivate func rightBarBtnAction() {
        if isDBOpened == true {
            //添加数据
            self.fmdbView.insertRow()
        }else{
            self.alert(title: "提示", message: "请先打开数据库！", duration: 1.5)
        }
    }
    
    @objc fileprivate func createDBBtnAction(btn: UIButton) {
        if isDBOpened == false {
            isDBOpened = true
            FMDBHelper.shareInstance.openDBQueue()
            btn.setTitleColor(RGB(28, 127, 253), for: .normal)
            btn.setTitle("关闭数据库", for: .normal)
            self.alert(title: "提示", message: "打开数据库", duration: 1.5)
        }else{
            isDBOpened = false
            FMDBHelper.shareInstance.closeDBQueue()
            btn.setTitleColor(UIColor.gray, for: .normal)
            btn.setTitle("打开数据库", for: .normal)
            self.alert(title: "提示", message: "关闭数据库", duration: 1.5)
        }
    }
    
    @objc fileprivate func selectBtnAction() {
        if isDBOpened == true {
            let result = FMDBHelper.shareInstance.selectAllQueue()
            if result == nil {
                self.alert(title: "提示", message: "数据库为空！", duration: 1.5)
            }
        }else{
            self.alert(title: "提示", message: "请先打开数据库！", duration: 1.5)
        }
    }
    
    @objc fileprivate func deleteBtnAction() {
        if isDBOpened == true {
            self.alert(title: "提示", message: "确定要删除数据库吗？") {
                FMDBHelper.shareInstance.dropQueue()
                self.createDBBtn.setTitle("打开数据库", for: .normal)
                self.createDBBtn.setTitleColor(UIColor.gray, for: .normal)
                self.isDBOpened = false
                self.insertID = 0
                self.fmdbView.model = nil
            }
        }else{
            self.alert(title: "提示", message: "请先打开数据库！", duration: 1.5)
        }
    }
    
}












