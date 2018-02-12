//
//  common.swift
//  HelloFMDB
//
//  Created by JOE on 2018/2/11.
//  Copyright © 2018年 Hongyear Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

import UIKit

///screenWidth
let screenWidth = UIScreen.main.bounds.size.width

///screenHeight
let screenHeight = UIScreen.main.bounds.size.height

///Documents路径
let DocumentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first

///数据库名称
let DBName = "student.sqlite"

///RGB
let RGB: (CGFloat, CGFloat, CGFloat) -> UIColor = { r,g,b in
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
}

///RGBA
let RGBA: (CGFloat, CGFloat, CGFloat, CGFloat) -> UIColor = { r,g,b,a in
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}

///StatusBarHeight
let statusBarHeight = UIApplication.shared.statusBarFrame.size.height

///NavigationBarHeight
let navigationBarHeight = CGFloat(44)

















