//
//  Access.swift
//  AssetsAccessExample
//
//  Created by Andrew Romanov on 28.11.2020.
//

import Foundation
import Photos

class Access {

    func access() -> PHAuthorizationStatus {
        return PHPhotoLibrary.authorizationStatus()
    }

    func requestAuthorization(withCompletion completion: @escaping (_ sender: Access) -> Void) {
        PHPhotoLibrary.requestAuthorization { [weak self] (status:PHAuthorizationStatus) in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                completion(self)
            }
        }
    }
}
