//
//  PickerWithoutAccess.swift
//  AssetsAccessExample
//
//  Created by Andrew Romanov on 29.11.2020.
//

import Foundation
import Photos
import PhotosUI

class PickerWithoutAccess: NSObject, PHPickerViewControllerDelegate {
    private var completion: ((_ image: UIImage?) -> Void)?

    func pickImage(in viewController: UIViewController, withCompletion completion: @escaping (_ image: UIImage?) -> Void) {
        if #available(iOS 14.0, *) {
            self.completion = completion
            var configuration = PHPickerConfiguration(photoLibrary: .shared())
            configuration.filter = PHPickerFilter.images
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            viewController.present(picker, animated: true, completion: nil)
        } else {
            completion(nil)
        }
    }

    //MARK: PHPickerViewControllerDelegate
    @available(iOS 14, *)
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.presentingViewController?.dismiss(animated: true, completion: nil)
        if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self ) { (imageReading: NSItemProviderReading?, error) in
                let image = imageReading as? UIImage
                self.notify(withImage: image)
            }

//            let imagesManager = PHImageManager.default()
//            let options = PHFetchOptions()
//            options.fetchLimit = 1
//            options.includeHiddenAssets = true
//            options.includeAllBurstAssets = true
//            let assets = PHAsset.fetchAssets(withLocalIdentifiers: [assetId],
//                                             options: options)
//            if let asset = assets.firstObject {
//                let bounds = UIScreen.main.bounds.applying(CGAffineTransform(scaleX: UIScreen.main.scale, y: UIScreen.main.scale))
//                let imageRequestOptions = PHImageRequestOptions()
//                imageRequestOptions.resizeMode = .fast
//                imageRequestOptions.isNetworkAccessAllowed = true
//                imageRequestOptions.deliveryMode = .opportunistic
//                _ = imagesManager.requestImage(for: asset,
//                                               targetSize: bounds.size,
//                                           contentMode: .aspectFill,
//                                           options: imageRequestOptions) { (image:UIImage?, _) in
//                    self.notify(withImage: image)
//                }
//            } else {
//                self.notify(withImage: nil)
//            }
        }
    }

    private func notify(withImage image: UIImage?) {
        guard let completion = self.completion else {
            return
        }
        if Thread.isMainThread {
            completion(image)
        } else {
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
}
