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
        if #available(iOS 14, *) {
            return PHPhotoLibrary.authorizationStatus(for: .readWrite)
        } else {
            return PHPhotoLibrary.authorizationStatus()
        }
    }

    @available(iOS 14.0, *)
    func access(for accessLevel: PHAccessLevel) -> PHAuthorizationStatus {
        return PHPhotoLibrary.authorizationStatus(for: accessLevel)
    }

    func requestAuthorization(withCompletion completion: @escaping (_ sender: Access) -> Void) {
        if #available(iOS 14.0, *) {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] (status:PHAuthorizationStatus) in
                guard let self = self else {
                    return
                }
                DispatchQueue.main.async {
                    completion(self)
                }
            }
        } else {
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

    @available(iOS 14.0, *)
    func requestAuthorization(for accessLevel: PHAccessLevel, withCompletion completion: @escaping (_ sender: Access) -> Void) {
        PHPhotoLibrary.requestAuthorization(for: accessLevel) { [weak self] (status:PHAuthorizationStatus) in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                completion(self)
            }
        }
    }
}
