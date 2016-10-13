//
//  GroupTableViewCell.swift
//  SwiftByPhoto
//
//  Created by David Yu on 22/7/15.
//  Copyright © 2015年 yanwei. All rights reserved.
//

import UIKit

class YWGroupTableViewCell: UITableViewCell {

    private var icon: UIImageView!
    private var title: UILabel!
    
    var name: String? {
        didSet {
            title.text = name
        }
    }
    
    var iconImage: UIImage? {
        didSet {
            icon.image = iconImage
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        icon = UIImageView(frame: CGRect(x: 10, y: 10, width: 60, height: 60))
        icon.backgroundColor = UIColor.white
        self.addSubview(icon)
        
        title = UILabel(frame: CGRect(x: 80, y: 20, width: UIScreen.main.bounds.width-100, height: 40))
        self.addSubview(title)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
