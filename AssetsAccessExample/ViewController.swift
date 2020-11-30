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
    @IBOutlet var selectImageWithoutAccessButton: UIButton!
    @IBOutlet var pickedImageView: UIImageView!
    @IBOutlet var askAllAccessButton: UIButton!
    @IBOutlet var askWriteOnlyAccessButton: UIButton!
    @IBOutlet var writeImageButton: UIButton!
    @IBOutlet var loadSavedAssets: UIButton!
    private var collectionController = RAVCollectionViewController()

    private let imagesManager = PHCachingImageManager()
    private let access = Access()
    private lazy var dataSource: DataSource = {
        let dataSource = DataSource()
        dataSource.delegate = self
        return dataSource
    }()

    private lazy var locationManager = CLLocationManager()
    private lazy var picker = PickerWithoutAccess()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configurePresenters()
        self.collectionController.setCollectionView(self.collectionView,
                                                    flowLayout: (self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout) )
        self.configureActions()
        let authList: [PHAuthorizationStatus]
        if #available(iOS 14.0, *) {
            authList = [.authorized, .limited]
        } else {
            authList = [.authorized]
        }
        if authList.contains(self.access.access()) {
            self.obtainAssets()
        }
        self.updateViewsVisibility()
    }

    private func notify(message: String) {
        let controller = UIAlertController(title: "", message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK",
                                           style: .default,
                                           handler: nil))
        self.present(controller, animated: true, completion: nil)
    }

    fileprivate func configureActions() {
        self.openSettingsButton.addTarget(self,
                                          action: #selector(self.goToSettingsAction(_:)),
                                          for: .touchUpInside)
        self.locationAccessButton.addTarget(self,
                                            action: #selector(self.getAccessForLocation(_:)),
                                            for: .touchUpInside)
        self.addImagesForSelectionButton.addTarget(self,
                                                   action: #selector(self.addPhotosIntoLimitedAccess(_:)),
                                                   for: .touchUpInside)
        self.selectImageWithoutAccessButton.addTarget(self,
                                                      action: #selector(self.selectWithoutAccess(_:)),
                                                      for: .touchUpInside)
        self.askAllAccessButton.addTarget(self,
                                          action: #selector(self.askAllAccess(_:)),
                                          for: .touchUpInside)
        if #available(iOS 14.0, *) {
            self.askWriteOnlyAccessButton.addTarget(self,
                                                    action: #selector(self.askWriteOnlyAccess(_:)),
                                                    for: .touchUpInside)
        }
        self.writeImageButton.addTarget(self,
                                        action: #selector(self.writeImage(_:)),
                                        for: .touchUpInside)
        self.loadSavedAssets.addTarget(self,
                                       action: #selector(self.loadSavedAssets(_:)),
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

    @objc private func selectWithoutAccess(_ sender: Any?) {
        self.picker.pickImage(in: self) { [weak self](result:UIImage?) in
            if let result = result {
                self?.pickedImageView.image = result
            } else {
                self?.notify(message: "Can't load asset")
            }
        }
    }

    @available(iOS 14, *)
    @objc private func askWriteOnlyAccess(_ sender: Any?) {
        self.access.requestAuthorization(for: .addOnly) { [weak self](sender) in
            guard let self = self else {
                return
            }
            self.updateViewsVisibility()
            self.obtainAssets()
        }
    }

    @objc private func askAllAccess(_ sender: Any?) {
        self.access.requestAuthorization { [weak self](sender) in
            guard let self = self else {
                return
            }
            self.updateViewsVisibility()
            self.obtainAssets()
        }
    }

    @objc private func writeImage(_ sender: Any?) {
        let image = UIImage(named: "1.jpg")!
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }

    @objc private func loadSavedAssets(_ sender: Any?) {

        let options = PHFetchOptions()
        let fetchResult:PHFetchResult<PHAsset> = PHAsset.fetchAssets(with: options)

        var uids = [String]()
        for index in 0..<fetchResult.count {
            uids.append(fetchResult.object(at: index).localIdentifier)
        }
        print("loaded uids: \(uids)")
    }
}

//MARK: Private methods
extension ViewController {
    private func authList(_ statuses:PHAuthorizationStatus...) -> [PHAuthorizationStatus] {
        let result = Array<PHAuthorizationStatus>(statuses)
        return result
    }

    private func configurePresenters() {
        collectionController.register(AssetImageCellModelPresenter(imageManager: self.imagesManager))
    }

    private func updateViewsVisibility() {
        let access = self.access.access()

        self.collectionView.isHidden = authList(.denied, .notDetermined, .restricted).contains(access)
        self.openSettingsButton.isHidden =  authList(.authorized, .notDetermined).contains(access)
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
        let shouldSelectWithoutAccess: Bool
        if #available(iOS 14.0, *) {
            shouldSelectWithoutAccess = authList(.denied, .restricted).contains(access)
        } else {
            shouldSelectWithoutAccess = false
        }
        self.selectImageWithoutAccessButton.isHidden = !shouldSelectWithoutAccess
        self.pickedImageView.isHidden = !shouldSelectWithoutAccess

        if #available(iOS 14.0 , *) {
            self.askAllAccessButton.isHidden = false
            self.askWriteOnlyAccessButton.isHidden = false
        } else {
            self.askAllAccessButton.isHidden = false
            self.askWriteOnlyAccessButton.isHidden = true
        }

        if #available(iOS 14.0, *) {
            let levels: [PHAuthorizationStatus] = [.authorized, .limited]
            let shouldHideWriteButton = (!levels.contains(self.access.access(for: .addOnly)) &&
                                            !levels.contains(self.access.access(for: .readWrite)))
            self.writeImageButton.isHidden = shouldHideWriteButton
            self.loadSavedAssets.isHidden = shouldHideWriteButton
        } else {
            self.writeImageButton.isHidden = self.access.access() != .authorized
            self.loadSavedAssets.isHidden = true
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

