//
//  DataSource.swift
//  AssetsAccessExample
//
//  Created by Andrew Romanov on 28.11.2020.
//

import Foundation
import Photos

class DataSource {

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
            let listModel = AssetsListModel(withFetchResult: result)
            DispatchQueue.main.async {
                completion(listModel)
            }
        }
    }
}
