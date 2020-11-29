//
//  DataSource.swift
//  AssetsAccessExample
//
//  Created by Andrew Romanov on 28.11.2020.
//

import Foundation
import Photos

protocol DataSourceDelegate: AnyObject {
    func photosLibraryChanged(_ sender: DataSource)
}

@objc class DataSource: NSObject, PHPhotoLibraryChangeObserver {
    weak var delegate: DataSourceDelegate?
    var fetchResult: PHFetchResult<PHAsset>?

    override init() {
        super.init()
        PHPhotoLibrary.shared().register(self)
    }



    func loadDataFromAlbum(_ album:PHAssetCollectionSubtype?, withCompletion completion: @escaping (_ listModel:AssetsListModel)->Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let options = PHFetchOptions()
            let result: PHFetchResult<PHAsset>
            if let album = album {
                let collectionOptions = PHFetchOptions()
                collectionOptions.fetchLimit = 1
                let collectionResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum,
                                                                         subtype: album,
                                                                         options: collectionOptions)
                if let firstCollection = collectionResult.firstObject {
                    result = PHAsset.fetchAssets(in: firstCollection, options: options)
                } else {
                    result = PHAsset.fetchAssets(with: options)
                }

            } else {
                result = PHAsset.fetchAssets(with: options)
            }
            self.fetchResult = result
            let listModel = AssetsListModel(withFetchResult: result)
            DispatchQueue.main.async {
                completion(listModel)
            }
        }
    }

    //MARK: PHPhotosLibraryObserver
    func photoLibraryDidChange(_ changeInstance: (PHChange)) {
        guard let fetchResult = self.fetchResult else {
            return
        }
        if changeInstance.changeDetails(for: fetchResult) != nil {
            DispatchQueue.main.async {
                self.delegate?.photosLibraryChanged(self)
            }
        }
    }
}



