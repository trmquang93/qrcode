//
//  QRLookupItemsViewController.swift
//  qrcode
//
//  Created by Quang Tran on 2/19/21.
//

import UIKit
import AppStarter
import RxSwift

class QRLookupItemsViewController: QRViewController, ASCollectionControllerWithViewModel {
    
    var scrollDirection: UICollectionView.ScrollDirection { return .vertical }
    
    var viewModel: VMLookupItems
    
    let didSelected = PublishSubject<VMLookupItems.Item>()
    
    init(viewModel: VMLookupItems = VMLookupItems()) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        collectionViewSource = ASCollectionDataSource(viewModel: viewModel, viewController: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(_ collectionView: UICollectionView, cell: UICollectionViewCell, at indexPath: IndexPath) {
        guard let cell = cell as? QRLookupItemCell, let item = viewModel.objectForIndexPath(indexPath) else { return }
        
        cell.imageView.image = UIImage(named: item.iconName)
    }
}

extension QRLookupItemsViewController: UICollectionViewDelegateFlowLayout {
    var itemSize: CGSize {
        let maxSize: CGFloat = collectionView.frame.size.width / 3 - 10
        return CGSize(width: min(maxSize, 100), height: min(maxSize / 2, 50))
    }
    
    var spacing: CGFloat {
        let numberOfItemsInRow = (collectionView.frame.width / itemSize.width).rounded(.down)
        let rowItemsTotalWidth = numberOfItemsInRow * itemSize.width
        let spacing = (collectionView.frame.width - rowItemsTotalWidth) / numberOfItemsInRow
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: spacing/2, left: spacing/2, bottom: spacing/2, right: spacing/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 23
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacing/2
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = viewModel.objectForIndexPath(indexPath) else { return }
        didSelected.onNext(item)
    }
}
