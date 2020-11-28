//
//  AssetsListModel.swift
//  AssetsAccessExample
//
//  Created by Andrew Romanov on 28.11.2020.
//

import Foundation
import Photos
import RAVPresentersKit

@objc class AssetsListModel: NSObject, RAVTableControllerListModelP {

    private let sections: [AssetsSectionModel]

    init(withFetchResult fetchResult: PHFetchResult<PHAsset>) {
        let section = AssetsSectionModel(withFetchResult: fetchResult)
        self.sections = [section]
        super.init()
    }

    func countSections() -> Int {
        return sections.count
    }

    func getSectionModel(forSection section: Int) -> RAVTableControllerSectionModelP! {
        return self.sections[section]
    }

    func getModelFor(_ indexPath: IndexPath!) -> Any! {
        return self.sections[indexPath.section].model(forRow: indexPath.row)
    }
}
