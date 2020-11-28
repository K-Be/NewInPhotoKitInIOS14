//
//  AssetImageCellModelPresenter.swift
//  AssetsAccessExample
//
//  Created by Andrew Romanov on 28.11.2020.
//

import Foundation
import Photos
import RAVPresentersKit
import RxSwift

class AssetImageCellModelPresenter: RAVCollectionViewPresenter {

    typealias ModelType = AssetImageCellModel
    typealias CellType = AssetImageCell
    let imageManager: PHImageManager

    init(imageManager: PHImageManager) {
        self.imageManager = imageManager
        super.init()
    }

    override func _registerViews() {
        super._registerViews()

        self.collectionView.register(CellType.nib, forCellWithReuseIdentifier: CellType.cellId)
    }

    override func canPresent(_ model: Any!) -> Bool {
        let can = model is ModelType
        return can
    }

    override func cell(forModel model: Any!, at indexPath: IndexPath!) -> UICollectionViewCell! {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: CellType.cellId, for: indexPath) as! CellType
        let model = model as! ModelType

        let cellSize = CellType.hintSize
        let requestOptions = PHImageRequestOptions()
        requestOptions.deliveryMode = .opportunistic
        requestOptions.isNetworkAccessAllowed = true
        requestOptions.resizeMode = .exact
        let requestId = self.imageManager.requestImage(for: model.asset,
                                                       targetSize: cellSize.applying(CGAffineTransform(scaleX: UIScreen.main.scale, y: UIScreen.main.scale)),
                                                       contentMode: PHImageContentMode.aspectFill,
                                                       options: requestOptions) { [weak cell] (image:UIImage?, _) in
            guard let image = image, let cell = cell else {
                return
            }
            cell.assetImageView.image = image
        }
        let discard = Disposables.create { [weak self] in
            guard let imageManager = self?.imageManager else {
                return
            }
            imageManager.cancelImageRequest(requestId)
        }
        cell.disposeBag = DisposeBag(disposing: [discard])

        return cell
    }

    override func size(forModel model: Any!, for indexPath: IndexPath!) -> CGSize {
        return CellType.hintSize
    }
}
