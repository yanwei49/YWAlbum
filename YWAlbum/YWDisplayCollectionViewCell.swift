//
//  DisplayCollectionViewCell.swift
//  SwiftByPhoto
//
//  Created by David Yu on 22/7/15.
//  Copyright © 2015年 yanwei. All rights reserved.
//

import UIKit

class YWDisplayCollectionViewCell: UICollectionViewCell {
    
    private var imageView: UIImageView!
    private var button: UIButton!
    private var checkBtn: UIButton!
    
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    var selectState: Bool? {
        didSet {
            button.alpha = selectState! ? 0.3 : 0
            checkBtn.isSelected = selectState!
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.red
        
        imageView = UIImageView(frame: self.bounds)
        imageView.backgroundColor = UIColor.white
        addSubview(imageView)
        
        button = UIButton(frame: self.bounds)
        button.isUserInteractionEnabled = false
        button.backgroundColor = UIColor.black
        button.alpha = 0;
        addSubview(button)
        
        checkBtn = UIButton()
        checkBtn.frame = CGRect(x: bounds.width-30, y: bounds.height-30, width: 20, height: 20)
        checkBtn.isUserInteractionEnabled = false
        checkBtn.setImage(UIImage(named: "gouxuan.png"), for: .selected)
        addSubview(checkBtn)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
