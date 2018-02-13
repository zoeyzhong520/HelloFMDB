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
    
    ///insertBtn
    var insertBtn:UIButton!
    
    ///selectAllBtn 全选按钮
    var selectAllBtn:UIButton!
    
    ///deleteBtn
    var deleteBtn:UIButton!
    
    ///leftBarBtn
    var leftBarBtn:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPage()
        getData()
        handleClosure()
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
    
    //MARK: - UI
    
    ///Set page
    fileprivate func setPage() {
        //设置导航栏
        self.title = "FMDB"
        isDBOpened = false
        view.backgroundColor = RGB(244, 244, 244)
        
        //FMDBView
        view.addSubview(fmdbView)
        
        leftBarBtn = UIButton(type: .system)
        leftBarBtn.setTitle("编辑", for: .normal)
        leftBarBtn.addTarget(self, action: #selector(leftBarBtnAction(btn:)), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarBtn)
        
        //insertBtn
        self.setInsertBtn()
        
        //创建数据库
        createDBBtn = UIButton(type: .system)
        createDBBtn.setTitleColor(UIColor.gray, for: .normal)
        createDBBtn.backgroundColor = RGB(244, 244, 244)
        createDBBtn.frame = CGRect(x: 0, y: view.bounds.size.height - 60, width: screenWidth / 3, height: 60)
        createDBBtn.setTitle("打开数据库", for: .normal)
        createDBBtn.addTarget(self, action: #selector(createDBBtnAction(btn:)), for: .touchUpInside)
        view.addSubview(createDBBtn)
        
        //查询按钮
        let selectBtn = UIButton(type: .system)
        selectBtn.backgroundColor = RGB(244, 244, 244)
        selectBtn.frame = CGRect(x: createDBBtn.frame.maxX, y: view.bounds.size.height - 60, width: screenWidth / 3, height: 60)
        selectBtn.setTitle("查询数据库", for: .normal)
        selectBtn.addTarget(self, action: #selector(selectBtnAction), for: .touchUpInside)
        view.addSubview(selectBtn)
        
        //删除按钮
        let deleteDBBtn = UIButton(type: .system)
        deleteDBBtn.backgroundColor = RGB(244, 244, 244)
        deleteDBBtn.frame = CGRect(x: selectBtn.frame.maxX, y: view.bounds.size.height - 60, width: screenWidth / 3, height: 60)
        deleteDBBtn.setTitle("删除数据库", for: .normal)
        deleteDBBtn.addTarget(self, action: #selector(deleteDBBtnAction), for: .touchUpInside)
        view.addSubview(deleteDBBtn)
    }
    
    ///Set insertBtn
    fileprivate func setInsertBtn() {
        insertBtn = UIButton(type: .system)
        insertBtn.setTitle("添加", for: .normal)
        insertBtn.addTarget(self, action: #selector(insertBtnAction), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: insertBtn)
    }
    
    ///Set selectAllBtn
    fileprivate func setSelectAllBtn() {
        //selectAllBtn
        selectAllBtn = UIButton(type: .system)
        selectAllBtn.setTitle("全选", for: .normal)
        selectAllBtn.addTarget(self, action: #selector(selectAllBtnAction), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: selectAllBtn)
    }
    
    ///Set deleteBtn
    fileprivate func setDeleteBtn() {
        deleteBtn = UIButton(frame: CGRect(x: 0, y: view.bounds.size.height - 60, width: view.bounds.size.width, height: 60))
        deleteBtn.setTitle("删除", for: .normal)
        deleteBtn.setTitleColor(UIColor.white, for: .normal)
        deleteBtn.addTarget(self, action: #selector(deleteBtnAction), for: .touchUpInside)
        
        deleteBtn.alpha = 0.0
        UIView.animate(withDuration: 0.3, animations: {
            self.deleteBtn.alpha = 1.0
        }) { (finished) in
            self.deleteBtn.backgroundColor = UIColor.red
            self.view.addSubview(self.deleteBtn)
        }
    }
    
    //MARK: - 数据 Data
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
    
    //MARK: - 处理点击闭包
    fileprivate func handleClosure() {
        fmdbView.deleteNumDidChangeBlock = { [weak self] deleteNum in
            if deleteNum == nil {
                return
            }
            self?.deleteBtn.setTitle("删除(\(deleteNum!))", for: .normal)
        }
        fmdbView.cellJumpClosure = { [weak self] student in
            let vc = FMDBDetailViewController()
            let studentID:Int = student.studentID == nil ? 0 : (student.studentID)!
            let name = student.name == nil ? "" : student.name
            let sex = student.sex == nil ? "" : student.sex
            let age:Int = student.age == nil ? 0 : (student.age)!
            vc.title = "\(studentID)" + name! + sex! + "\(age)"
            
            //背景色
            let r = CGFloat(Int(arc4random() % 255)) * 1.0
            let g = CGFloat(Int(arc4random() % 255)) * 1.0
            let b = CGFloat(Int(arc4random() % 255)) * 1.0
            vc.view.backgroundColor = RGB(r, g, b)
            
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: - 点击按钮的Action
    @objc fileprivate func leftBarBtnAction(btn: UIButton) {
        let result = FMDBHelper.shareInstance.selectAllQueue()
        if result == nil {
            self.alert(title: "提示", message: "数据库为空！", duration: 1.5)
            return
        }
        
        //编辑
        if fmdbView.tableView.isEditing == true {
            btn.setTitle("编辑", for: .normal)
            fmdbView.tableView.setEditing(false, animated: true)
            //1.insertBtn
            self.setInsertBtn()
            //2.deleteBtn
            deleteBtn.alpha = 1.0
            UIView.animate(withDuration: 0.3, animations: {
                self.deleteBtn.alpha = 0.0
            }, completion: { (finished) in
                if self.deleteBtn != nil {
                    self.deleteBtn.removeFromSuperview()
                }
            })
            //3.selectAllBtn
            if selectAllBtn != nil {
                selectAllBtn.removeFromSuperview()
            }
            
            fmdbView.deleteArray.removeAll() //deleteArray
            fmdbView.deleteNum = nil //deleteNum
        }else{
            btn.setTitle("取消", for: .normal)
            fmdbView.tableView.setEditing(true, animated: true)
            //1.insertBtn
            if insertBtn != nil {
                insertBtn.removeFromSuperview()
            }
            //2.deleteBtn
            self.setDeleteBtn()
            //3.selectAllBtn
            self.setSelectAllBtn()
        }
    }
    
    @objc fileprivate func insertBtnAction() {
        if isDBOpened == true {
            //添加数据
            self.fmdbView.insertRow()
        }else{
            self.alert(title: "提示", message: "请先打开数据库！", duration: 1.5)
        }
    }
    
    @objc fileprivate func selectAllBtnAction() {
        fmdbView.selectAllRows()
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
    
    @objc fileprivate func deleteDBBtnAction() {
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
    
    
    @objc fileprivate func deleteBtnAction() {
        if fmdbView.tableView.isEditing == true {
            fmdbView.tableView.setEditing(false, animated: true)
            leftBarBtn.setTitle("编辑", for: .normal)
            fmdbView.tableView.setEditing(false, animated: true)
            //1.insertBtn
            self.setInsertBtn()
            //2.deleteBtn
            deleteBtn.alpha = 1.0
            UIView.animate(withDuration: 0.3, animations: {
                self.deleteBtn.alpha = 0.0
            }, completion: { (finished) in
                if self.deleteBtn != nil {
                    self.deleteBtn.removeFromSuperview()
                }
            })
            //3.selectAllBtn
            if selectAllBtn != nil {
                selectAllBtn.removeFromSuperview()
            }
            
            //删除数据
            fmdbView.deleteRows()
        }
    }
}












