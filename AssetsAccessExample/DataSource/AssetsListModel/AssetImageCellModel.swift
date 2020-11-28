//
//  AssetImageCellModel.swift
//  AssetsAccessExample
//
//  Created by Andrew Romanov on 28.11.2020.
//

import Foundation
import Photos

@objc class AssetImageCellModel: NSObject {
    let asset: PHAsset

    init(withAsset asset: PHAsset) {
        self.asset = asset
    }
}
