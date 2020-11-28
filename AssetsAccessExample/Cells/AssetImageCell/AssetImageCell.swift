//
//  AssetImageCell.swift
//  AssetsAccessExample
//
//  Created by Andrew Romanov on 28.11.2020.
//

import Foundation
import UIKit
import RxSwift

class AssetImageCell: UICollectionViewCell{
    @IBOutlet var assetImageView: UIImageView!
    var disposeBag: DisposeBag?

    override func awakeFromNib() {
        super.awakeFromNib()
        #if targetEnvironment(macCatalyst)
        let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        self.contentView.addSubview(effectView)

        effectView.translatesAutoresizingMaskIntoConstraints = false
        effectView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        effectView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        effectView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
        effectView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        #endif
    }

    static let hintSize: CGSize = {
        let size: CGSize
        if UIDevice.current.userInterfaceIdiom == .pad {
            size = CGSize(width: 100.0, height: 100.0)
        } else {
            size = CGSize(width: 50.0, height: 50.0)
        }
        return size
    }()
    static let nib: UINib  = {
        let nib = UINib(nibName: "AssetImageCell", bundle: Bundle.main)
        return nib
    }()
    static let cellId = "AssetImageCell"

    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = nil
        self.assetImageView.image = nil
    }

}
