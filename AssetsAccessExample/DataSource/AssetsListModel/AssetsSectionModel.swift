//
//  AssetsSectionModel.swift
//  AssetsAccessExample
//
//  Created by Andrew Romanov on 28.11.2020.
//

import Foundation
import Photos
import RAVPresentersKit

@objc class AssetsSectionModel: NSObject, RAVTableControllerSectionModelP {

    var headerViewModel: Any?
    var footerViewModel: Any?
    let fetchResult: PHFetchResult<PHAsset>

    init(withFetchResult fetchResult: PHFetchResult<PHAsset>) {
        self.fetchResult = fetchResult
        super.init()
    }

    func numberObjects() -> Int {
        return fetchResult.count
    }

    func model(forRow rowIndex: Int) -> Any! {
        return AssetImageCellModel(withAsset: self.fetchResult.object(at: rowIndex))
    }
}
