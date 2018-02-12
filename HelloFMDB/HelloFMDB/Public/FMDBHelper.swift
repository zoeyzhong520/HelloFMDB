//
//  FMDBHelper.swift
//  HelloFMDB
//
//  Created by JOE on 2018/2/11.
//  Copyright © 2018年 Hongyear Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

import UIKit

class FMDBHelper: NSObject {

    static let shareInstance = FMDBHelper()
    private override init() {}
    
    ///FMDatabase对象
    var db:FMDatabase?
    
    ///FMDatabaseQueue对象
    var queue:FMDatabaseQueue?
    
    //MARK: - FMDatabase 单线程
    //MARK: OPEN DB
    ///打开数据库
    func openDB() {
        
        guard let doc = DocumentPath else { return }
        let fileName = (doc as NSString).appendingPathComponent(DBName)
        
        //获得数据库
        let db = FMDatabase(path: fileName)
        self.db = db
        
        //使用如下语句，如果打开失败，可能是权限不足或者资源不足。通常打开完操作操作后，需要调用 close 方法来关闭数据库。在和数据库交互 之前，数据库必须是打开的。如果资源或权限不足无法打开或创建数据库，都会导致打开失败
        if db.open() == true {
            //创表
            let result = db.executeStatements("CREATE TABLE IF NOT EXISTS t_student (studentID integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, sex text NOT NULL, age integer NOT NULL);")
            if result == true {
                print("创建表成功！")
            }
        }
    }
    
    //MARK: CLOSE
    ///关闭数据库
    func closeDB() {
        if self.db != nil {
            self.db?.close()
        }
    }
    
    //MARK: INSERT
    ///向数据库插入数据
    func insert(studentID: Int, name: String, sex: String, age: Int) {
        //1.executeUpdate:不确定的参数用？来占位（后面参数必须是oc对象，；代表语句结束）
        do {
            try self.db?.executeUpdate("INSERT INTO t_student (studentID, name, sex, age) VALUES (?,?,?,?);", values: [studentID, name, sex, age])
        } catch let error {
            print("failed: \(error.localizedDescription)")
        }
    }
    
    //MARK: DELETE
    ///根据ID从数据库删除数据
    func deleteByID(studentID: Int) {
        do {
            try self.db?.executeUpdate("delete from t_student where id = ?;", values: [studentID])
        } catch let error {
            print("failed: \(error.localizedDescription)")
        }
    }
    
    ///根据name从数据库删除数据
    func deleteByName(name: String) {
        do {
            try self.db?.executeUpdate("delete from t_student where name = %@;", values: [name])
        } catch let error {
            print("failed: \(error.localizedDescription)")
        }
    }
    
    //MARK: UPDATE
    func updateName(newName: String, oldName: String) {
        do {
            try self.db?.executeUpdate("update t_student set name = ? where name = ?", values: [newName, oldName])
        } catch let error {
            print("failed: \(error.localizedDescription)")
        }
    }
    
    //MARK: SELECT
    ///查询整个表
    func selectAll() {
        do {
            guard let rs = try self.db?.executeQuery("select * from t_student;", values: nil) else {
                return
            }
            //遍历结果集合
            while rs.next() {
                if let name = rs.string(forColumn: "name"), let sex = rs.string(forColumn: "sex") {
                    
                    let studentID = rs.longLongInt(forColumn: "studentID")
                    let age = rs.longLongInt(forColumn: "age")
                    
                    print("studentID = \(studentID), name = \(name), sex = \(sex), age = \(age)")
                }
            }
        } catch let error {
            print("failed: \(error.localizedDescription)")
        }
    }
    
    ///根据条件studentId查询
    func selectByCondition(condition: String="", studentId: Int=0) -> Student? {
        do {
            let tmpCondition = condition == "" ? "select * from t_student;" : condition //条件语句为空就默认查询全部
            let values = studentId == 0 ? nil : [studentId]
            
            guard let rs = try self.db?.executeQuery(tmpCondition, values: values) else {
                return nil
            }
            //遍历结果集合
            while rs.next() {
                if let name = rs.string(forColumn: "name"), let sex = rs.string(forColumn: "sex") {
                    
                    let studentID = rs.longLongInt(forColumn: "studentID")
                    let age = rs.longLongInt(forColumn: "age")
                    
                    print("studentID = \(studentID), name = \(name), sex = \(sex), age = \(age)")
                    
                    let model = Student()
                    model.studentID = Int(studentID)
                    model.name = name
                    model.sex = sex
                    model.age = Int(age)
                    return model
                }
            }
        } catch let error {
            print("failed: \(error.localizedDescription)")
            return nil
        }
        return nil
    }
    
    //MARK: DROP
    ///如果表格存在 则销毁
    func drop() {
        do {
            try self.db?.executeUpdate("drop table if exists t_student;", values: nil)
        } catch let error {
            print("failed: \(error.localizedDescription)")
        }
    }
    
    //MARK: - FMDatabaseQueue 多线程
    //MARK: OPEN DB Queue
    func openDBQueue() {
        guard let doc = DocumentPath else { return }
        let fileName = (doc as NSString).appendingPathComponent(DBName)
        
        self.queue = FMDatabaseQueue(path: fileName)
        self.queue?.inDatabase({ (db) in
            //创表
            let result = db.executeStatements("CREATE TABLE IF NOT EXISTS t_student (studentID integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, sex text NOT NULL, age integer NOT NULL);")
            if result == true {
                print("创建表成功！")
            }else{
                print("创建表失败！")
            }
        })
    }
    
    //MARK: CLOSE
    func closeDBQueue() {
        self.queue?.inDatabase({ (db) in
            db.close()
        })
    }
    
    //MARK: INSERT
    func insertQueue(studentID: Int, name: String, sex: String, age: Int) {
        self.queue?.inDatabase({ (db) in
            do {
                try db.executeUpdate("INSERT INTO t_student (studentID, name, sex, age) VALUES (?,?,?,?);", values: [studentID, name, sex, age])
            } catch let error {
                print("failed: \(error.localizedDescription)")
            }
        })
    }
    
    //MARK: DELETE
    func deleteByIDQueue(studentID: Int) {
        self.queue?.inDatabase({ (db) in
            do {
                try db.executeUpdate("delete from t_student where id = ?;", values: [studentID])
            } catch let error {
                print("failed: \(error.localizedDescription)")
            }
        })
    }
    
    func deleteByNameQueue(name: String) {
        self.queue?.inDatabase({ (db) in
            do {
                try db.executeUpdate("delete from t_student where name = %@;", values: [name])
            } catch let error {
                print("failed: \(error.localizedDescription)")
            }
        })
    }
    
    //MARK: UPDATE
    func updateNameQueue(newName: String, oldName: String) {
        self.queue?.inDatabase({ (db) in
            do {
                try db.executeUpdate("update t_student set name = ? where name = ?", values: [newName, oldName])
            } catch let error {
                print("failed: \(error.localizedDescription)")
            }
        })
    }
    
    //MARK: SELECT
    func selectAllQueue() -> [Student]? {
        var result:[Student]? = nil
        
        self.queue?.inDatabase({ (db) in
            do {
                let rs = try db.executeQuery("select * from t_student;", values: nil)
                
                //遍历结果集合
                var modelArray = [Student]()
                while rs.next() {
                    if let name = rs.string(forColumn: "name"), let sex = rs.string(forColumn: "sex") {
                        
                        let studentID = rs.longLongInt(forColumn: "studentID")
                        let age = rs.longLongInt(forColumn: "age")
                        
                        print("studentID = \(studentID), name = \(name), sex = \(sex), age = \(age)")
                        
                        let model = Student()
                        model.studentID = Int(studentID)
                        model.name = name
                        model.sex = sex
                        model.age = Int(age)
                        
                        modelArray.append(model)
                        result = modelArray
                    }
                }
            } catch let error {
                result = nil
                print("failed: \(error.localizedDescription)")
            }
        })
        return result
    }
    
    func selectByConditionQueue(condition: String="", studentId: Int=0) -> Student? {
        var resultModel:Student?
        
        self.queue?.inDatabase({ (db) in
            do {
                let tmpCondition = condition == "" ? "select * from t_student;" : condition //条件语句为空就默认查询全部
                let values = studentId == 0 ? nil : [studentId]
                
                let rs = try db.executeQuery(tmpCondition, values: values)
                
                //遍历结果集合
                while rs.next() {
                    if let name = rs.string(forColumn: "name"), let sex = rs.string(forColumn: "sex") {
                        
                        let studentID = rs.longLongInt(forColumn: "studentID")
                        let age = rs.longLongInt(forColumn: "age")
                        
                        print("studentID = \(studentID), name = \(name), sex = \(sex), age = \(age)")
                        
                        let model = Student()
                        model.studentID = Int(studentID)
                        model.name = name
                        model.sex = sex
                        model.age = Int(age)
                        resultModel = model
                    }
                }
            } catch let error {
                resultModel = nil
                print("failed: \(error.localizedDescription)")
            }
        })
        return resultModel
    }
    
    //MARK: DROP
    func dropQueue() {
        self.queue?.inDatabase({ (db) in
            do {
                try db.executeUpdate("drop table if exists t_student;", values: nil)
            } catch let error {
                print("failed: \(error.localizedDescription)")
            }
        })
    }
}

















