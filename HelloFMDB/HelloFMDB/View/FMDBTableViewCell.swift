//
//  FMDBTableViewCell.swift
//  HelloFMDB
//
//  Created by JOE on 2018/2/12.
//  Copyright © 2018年 Hongyear Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

import UIKit

class FMDBTableViewCell: UITableViewCell {

    var model:Student? {
        didSet {
            showData()
        }
    }
    
    ///Show Data
    fileprivate func showData() {
        for view in self.contentView.subviews {
            view.removeFromSuperview()
        }
        
        let studentID:Int = model?.studentID == nil ? 0 : (model?.studentID)!
        let name = model?.name == nil ? "" : model?.name
        let sex = model?.sex == nil ? "" : model?.sex
        let age:Int = model?.age == nil ? 0 : (model?.age)!
        
        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x: 0, y: 0, width: self.contentView.bounds.size.width, height: self.contentView.bounds.size.height - 1)
        titleLabel.text = "\(studentID)      " + name! + "      " + sex! + "      " + "  \(age)"
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = .center
        self.contentView.addSubview(titleLabel)
        
        //LineView
        let lineView = UIView()
        lineView.frame = CGRect(x: 0, y: titleLabel.frame.maxY, width: self.contentView.bounds.size.width, height: 1)
        lineView.backgroundColor = RGB(244, 244, 244)
        self.contentView.addSubview(lineView)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension FMDBTableViewCell {
    
    ///创建cell的方法
    class func createCell(tableView: UITableView, atIndexPath indexPath: IndexPath) -> FMDBTableViewCell {
        
        let cellID = "FMDBTableViewCellId"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? FMDBTableViewCell
        if cell == nil {
            print("创建cell失败！    ")
        }
        return cell!
    }
}
















