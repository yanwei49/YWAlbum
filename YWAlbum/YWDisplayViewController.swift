//
//  DisplayViewController.swift
//  SwiftByPhoto
//
//  Created by David Yu on 22/7/15.
//  Copyright © 2015年 yanwei. All rights reserved.
//

import UIKit
import Photos

protocol YWDisplayViewControllerDelegate {
    func displayViewControllerDidSeletedAsset(asset: PHAsset);
    func displayViewControllerDidSeletedAssets(assets: [PHAsset]);
}

class YWDisplayViewController: UIViewController {

    var fetchResult: PHFetchResult<AnyObject>!
    /// 选中的asset数组
    var selectedAssets: [PHAsset]?
    var type: YWSeletedPictureType!
    var delegate: YWDisplayViewControllerDelegate?
    
    private var collectionView: UICollectionView!
    
    /// 图片管理者
    var imageManager: PHCachingImageManager!
    var rightItem: UIBarButtonItem!
    
    /// Collection item的宽
    let itemWidth = (YWScreenWidth-20-YWCollectionItemSpace*3)/4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        rightItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.plain, target: self, action: #selector(YWDisplayViewController.actionRightItem))
        navigationItem.rightBarButtonItem = rightItem
        
        if selectedAssets == nil {
            selectedAssets = [PHAsset]()
        }else {
            rightItem.title = "确定"
        }
        
        imageManager = PHCachingImageManager()
        createCollectionView()
    }

    /// 创建collectionView
    func createCollectionView() {
        let layout = UICollectionViewFlowLayout()
        
        collectionView = UICollectionView(frame: CGRect(x: 10, y: 10, width: YWScreenWidth-20, height: YWScreenHeigth), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        collectionView.register(YWDisplayCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "cell")
        view.addSubview(collectionView)
    }
    
    /// 右导航事件
    func actionRightItem() {
        let _ = navigationController?.popViewController(animated: false)
        if type != .onePicture {
            let _ = navigationController?.popViewController(animated: false)
            delegate?.displayViewControllerDidSeletedAssets(assets: selectedAssets!)
        }
    }
    
}

extension YWDisplayViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! YWDisplayCollectionViewCell
        let asset = fetchResult[indexPath.row] as! PHAsset
        for at in selectedAssets! {
            if at == asset {
                cell.selectState = true
            }
        }
        imageManager.requestImage(for: asset, targetSize: CGSize(width: itemWidth, height: itemWidth), contentMode: .aspectFill, options: nil) { (result, info) -> Void in
            cell.image = result
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath as IndexPath) as! YWDisplayCollectionViewCell
        let asset = fetchResult[indexPath.row] as! PHAsset
        if type == .onePicture {
            let _ = navigationController?.popViewController(animated: false)
            delegate?.displayViewControllerDidSeletedAsset(asset: asset)
        }else {
            if cell.selectState == true {
                cell.selectState = false
                selectedAssets?.remove(at: (selectedAssets?.index(of: asset))!)
            }else {
                cell.selectState = true
                selectedAssets?.append(asset)
            }
            if selectedAssets?.count != 0 {
                rightItem.title = "确定"
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return YWCollectionItemSpace
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return YWCollectionItemSpace
    }

}
