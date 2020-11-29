//
//  ViewController.swift
//  AssetsAccessExample
//
//  Created by Andrew Romanov on 28.11.2020.
//

import UIKit
import RAVPresentersKit
import Photos
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var openSettingsButton: UIButton!
    @IBOutlet var locationAccessButton: UIButton!
    private var collectionController = RAVCollectionViewController()

    private let imagesManager = PHCachingImageManager()
    private let access = Access()
    private let dataSource = DataSource()

    private lazy var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.configurePresenters()
        self.collectionController.setCollectionView(self.collectionView,
                                                    flowLayout: (self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout) )
        self.updateViewsVisibility()
        if self.access.access() == .notDetermined {
            self.access.requestAuthorization { [weak self](sender) in
                guard let self = self else {
                    return
                }
                self.updateViewsVisibility()
                self.obtainAssets()
            }
        } else if self.access.access() == .authorized {
            self.obtainAssets()
        }

        self.openSettingsButton.addTarget(self,
                                          action: #selector(self.goToSettingsAction(_:)),
                                          for: .touchUpInside)
        self.locationAccessButton.addTarget(self,
                                            action: #selector(self.getAccessForLocation(_:)),
                                            for: .touchUpInside)
    }

}

//MARK: Private methods
extension ViewController {
    private func configurePresenters() {
        collectionController.register(AssetImageCellModelPresenter(imageManager: self.imagesManager))
    }

    @objc private func goToSettingsAction(_ sender: Any?) {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!,
                                  options: [UIApplication.OpenExternalURLOptionsKey : Any](),
                                  completionHandler: nil)
    }

    @objc private func getAccessForLocation(_ sender: Any?) {
        self.locationManager.requestAlwaysAuthorization()
    }

    private func updateViewsVisibility() {
        let access = self.access.access()

        let builder = { (array: [PHAuthorizationStatus]) -> [PHAuthorizationStatus] in
            return array
        }

        self.collectionView.isHidden = builder([.denied, .notDetermined, .restricted]).contains(access)
        self.openSettingsButton.isHidden = builder([.authorized, .notDetermined]).contains(access)
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

