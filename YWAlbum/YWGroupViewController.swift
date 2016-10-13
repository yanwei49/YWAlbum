//
//  GropViewController.swift
//  SwiftByPhoto
//
//  Created by David Yu on 22/7/15.
//  Copyright © 2015年 yanwei. All rights reserved.
//

import UIKit
import Photos


/// 选图的模式
///
/// - onePicture:  单图选择
/// - morePicture: 多图选择
enum YWSeletedPictureType {
    case onePicture
    case morePicture
}

protocol YWGroupViewControllerDelegate {
    func groupViewControllerDidSeletedAsset(asset: PHAsset);
    func groupViewControllerDidSeletedAssets(assets: [PHAsset]);
}

class YWGroupViewController: UIViewController {
    
    var type: YWSeletedPictureType!
    //选中的asset数组
    var selectedAssets: [PHAsset]?
    var delegate: YWGroupViewControllerDelegate?
    
    var collectionsFetchResults: PHFetchResult<PHAssetCollection>!
    var _tableView: UITableView!
    var imageManager: PHCachingImageManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        imageManager = PHCachingImageManager()
        //获取系统相册中的相册分组
        collectionsFetchResults = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
        
        createTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _tableView.reloadData()
    }
    
    func createTableView() {
        _tableView = UITableView(frame: view.bounds, style: .plain)
        _tableView.backgroundColor = UIColor.white
        _tableView.register(YWGroupTableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        _tableView.tableFooterView = UIView()
        _tableView.delegate = self
        _tableView.dataSource = self
        view .addSubview(_tableView)
    }

}

extension YWGroupViewController: YWDisplayViewControllerDelegate {
    
    /// YWDisplayViewController代理回调
    func displayViewControllerDidSeletedAsset(asset: PHAsset) {
        let _ = navigationController?.popViewController(animated: false)
        delegate?.groupViewControllerDidSeletedAsset(asset: asset)
    }
    
    func displayViewControllerDidSeletedAssets(assets: [PHAsset]) {
        let _ = navigationController?.popViewController(animated: false)
        delegate?.groupViewControllerDidSeletedAssets(assets: assets)
    }
}

extension YWGroupViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collectionsFetchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! YWGroupTableViewCell
        let collection = collectionsFetchResults[indexPath.row]
        let fecResult = PHAsset.fetchAssets(in: collection, options: nil) as PHFetchResult
        let asset = fecResult[indexPath.row]
        imageManager.requestImage(for: asset, targetSize: CGSize(width: 60, height: 60), contentMode: .aspectFill, options: nil) { (result, info) -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                cell.iconImage = result;
                cell.name = "\(collection.localizedTitle!)" + " (" + "\(fecResult.count)" + ")"
            })
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let displayVC = YWDisplayViewController()
        let collection = collectionsFetchResults[indexPath.row]
        let assetFetchResult = PHAsset.fetchAssets(in: collection, options: nil) as! PHFetchResult<AnyObject>
        displayVC.fetchResult = assetFetchResult
        displayVC.type = type
        displayVC.delegate = self
        if selectedAssets != nil {
            displayVC.selectedAssets = selectedAssets
        }
        navigationController?.show(displayVC, sender: nil)
    }
}

