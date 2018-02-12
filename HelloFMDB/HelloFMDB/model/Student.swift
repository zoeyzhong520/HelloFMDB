//
//  Student.swift
//  HelloFMDB
//
//  Created by JOE on 2018/2/11.
//  Copyright © 2018年 Hongyear Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

import UIKit

class Student: NSObject {

    ///学生ID
    var studentID:Int?
    ///学生姓名
    var name:String?
    ///学生性别
    var sex:String?
    ///学生年龄
    var age:Int?
    
    class func create(studentID:Int?, name:String?, sex:String?, age:Int?) -> Student {
        let model = Student()
        model.studentID = studentID
        model.name = name
        model.sex = sex
        model.age = age
        return model
    }
}
