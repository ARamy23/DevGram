//
//  PhotoSelectorVC.swift
//  Devgram
//
//  Created by ScaRiLiX on 10/1/18.
//  Copyright © 2018 ScaRiLiX. All rights reserved.
//

import UIKit
import Photos

class PhotoSelectorVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    //MARK:- Datasource
    
    var images = [UIImage]()
    var assets = [PHAsset]()
    
    //MARK:- Instance Variables
    
    var selectedImage: UIImage?
    var header: PhotoSelectorHeader?
    
    //MARK:- View Controller Methods
    
    override var prefersStatusBarHidden: Bool
    {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchPhotos()
        setupCollectionView()
        setupNavCon()
    }

    //MARK:- Setup Methods
    
    fileprivate func setupCollectionView()
    {
        collectionView.register(cellWithClass: PhotoCollectionCell.self)
        collectionView.register(supplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withClass: PhotoSelectorHeader.self)
        collectionView.backgroundColor = .white
    }
    
    fileprivate func setupNavCon()
    {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNext))
    }
    
    //MARK:- Logic
    
    fileprivate func fetchPhotos()
    {
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 10
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchOptions.sortDescriptors = [sortDescriptor]
        let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        DispatchQueue.global(qos: .background).async
        { [weak self] in
            allPhotos.enumerateObjects { (asset, count, stop) in
                
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 200, height: 200)
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options, resultHandler: { (image, info) in
                    if let image = image
                    {
                        self?.images.append(image)
                        self?.assets.append(asset)
                        if self?.selectedImage == nil
                        {
                            self?.selectedImage = image
                        }
                    }
                    
                    if count == allPhotos.count - 1
                    {
                        DispatchQueue.main.async { [weak self] in self?.collectionView.reloadData() }
                    }
                })
            }
        }
    }
    
    @objc fileprivate func handleNext()
    {
        let sharePhotoVC = SharePhotoVC()
        sharePhotoVC.imageView.image = header?.photoImageView.image
        navigationController?.pushViewController(sharePhotoVC )
    }
    
    @objc fileprivate func handleCancel()
    {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK:- UICollectionView Methods

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withClass: PhotoSelectorHeader.self, for: indexPath)
        header.photoImageView.image = selectedImage
        
        self.header = header
        
        if let selectedImage = selectedImage, let index = images.index(of: selectedImage)
        {
            let selectedAsset = assets[index]
            let imageManager = PHImageManager.default()
            let targetSize = CGSize(width: 600, height: 600)
            imageManager.requestImage(for: selectedAsset, targetSize: targetSize, contentMode: .default, options: nil) { (image, info) in
                header.photoImageView.image = image
            }
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.width, height: view.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: PhotoCollectionCell.self, for: indexPath)
        let image = images[indexPath.item]
        cell.photoImageView.image = image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.width - 3) / 4, height: view.width / 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedImage = images[indexPath.item]
        collectionView.reloadData()
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .bottom, animated: true)
    }
}
