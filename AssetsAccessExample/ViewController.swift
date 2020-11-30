//
//  ViewController.swift
//  AssetsAccessExample
//
//  Created by Andrew Romanov on 28.11.2020.
//

import UIKit
import RAVPresentersKit
import Photos
import PhotosUI
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var openSettingsButton: UIButton!
    @IBOutlet var locationAccessButton: UIButton!
    @IBOutlet var addImagesForSelectionButton: UIButton!
    private var collectionController = RAVCollectionViewController()

    private let imagesManager = PHCachingImageManager()
    private let access = Access()
    private lazy var dataSource: DataSource =  {
        let dataSource = DataSource()
        dataSource.delegate = self
        return dataSource
    }()

    private lazy var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configurePresenters()
        self.collectionController.setCollectionView(self.collectionView,
                                                    flowLayout: (self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout) )
        self.updateViewsVisibility()
        self.access.requestAuthorization { [weak self](sender) in
            guard let self = self else {
                return
            }
            self.updateViewsVisibility()
            self.obtainAssets()
        }

        self.openSettingsButton.addTarget(self,
                                          action: #selector(self.goToSettingsAction(_:)),
                                          for: .touchUpInside)
        self.locationAccessButton.addTarget(self,
                                            action: #selector(self.getAccessForLocation(_:)),
                                            for: .touchUpInside)
        self.addImagesForSelectionButton.addTarget(self,
                                                   action: #selector(self.addPhotosIntoLimitedAccess(_:)),
                                                   for: .touchUpInside)
    }

}

//MARK: Actions
extension ViewController {
    @objc private func goToSettingsAction(_ sender: Any?) {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!,
                                  options: [UIApplication.OpenExternalURLOptionsKey : Any](),
                                  completionHandler: nil)
    }

    @objc private func getAccessForLocation(_ sender: Any?) {
        self.locationManager.requestWhenInUseAuthorization()
    }

    @objc private func addPhotosIntoLimitedAccess(_ sender: Any?) {
        if #available(iOS 14.0, *) {
            PHPhotoLibrary.shared().presentLimitedLibraryPicker(from:self)
        }
    }
}

//MARK: Private methods
extension ViewController {
    private func configurePresenters() {
        collectionController.register(AssetImageCellModelPresenter(imageManager: self.imagesManager))
    }

    private func updateViewsVisibility() {
        let access = self.access.access()

        let builder = { (array: [PHAuthorizationStatus]) -> [PHAuthorizationStatus] in
            return array
        }

        self.collectionView.isHidden = builder([.denied, .notDetermined, .restricted]).contains(access)
        self.openSettingsButton.isHidden = builder([.authorized, .notDetermined]).contains(access)
        let isLimitedAccess: Bool
        if #available(iOS 14.0, *) {
            isLimitedAccess = (access == .limited)
        } else {
            isLimitedAccess = false
        }
        self.addImagesForSelectionButton.isHidden = !isLimitedAccess
        if #available(iOS 14.0, *) {
            if access == .limited {
                self.openSettingsButton.setTitle("Limited access, open settings", for: .normal)
            } else {
                self.openSettingsButton.setTitle("No access, open settings", for: .normal)
            }
        }
    }

    private func obtainAssets() {
        self.dataSource.loadDataFromAlbum(nil) { [weak self] (listModel:AssetsListModel) in
            guard let self = self else {
                return
            }
            self.collectionController.model = listModel
        }
    }
}

//MARK: DataSourceDelegate
extension ViewController: DataSourceDelegate {
    func photosLibraryChanged(_ sender: DataSource) {
        self.obtainAssets()
    }
}

