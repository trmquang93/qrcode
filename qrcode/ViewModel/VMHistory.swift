//
//  VMHistory.swift
//  qrcode
//
//  Created by Quang Tran on 2/8/21.
//

import Foundation
import AppStarter
import RealmSwift
import RxSwift
import RxCocoa


class VMHistory: ASViewModelListData {
    var itemIdentifiers: [String : AnyClass] {
        [
            QRHistoryCell.className : QRHistoryCell.self
        ]
    }
    
    var items: Results<RLMScanHistory>! = {
        let realm = try! Realm()
        return realm.objects(RLMScanHistory.self).sorted(byKeyPath: "date", ascending: false)
    }()
    
    init() {
        observeChanges()
    }
    
    let isSelecting = BehaviorRelay<Bool>(value: false)
    let selectingIndexPaths = BehaviorRelay<Set<IndexPath>>(value: [])
    let selectingAll = BehaviorRelay<Bool>(value: false)
    let shouldShowAccessory = BehaviorRelay<IndexPath?>(value: nil)
    lazy var canSelect = Observable.collection(from: items).map({$0.count > 0})
}

extension VMHistory {
    func disableSelection() {
        isSelecting.accept(false)
    }
    
    func selection() {
        shouldShowAccessory.accept(nil)
        let isSelecting = self.isSelecting.value
        
        if isSelecting {
            let selectingAll = self.selectingAll.value
            self.selectingAll.accept(!selectingAll)
            if selectingAll {
                self.selectingIndexPaths.accept([])
            }
        } else {
            self.selectingIndexPaths.accept([])
            self.selectingAll.accept(false)
            self.isSelecting.accept(true)
        }
    }
    
    func selectIndexPath(_ indexPath: IndexPath) {
        shouldShowAccessory.accept(nil)
        var selectingIndexPaths = self.selectingIndexPaths.value
        if selectingIndexPaths.remove(indexPath) == nil {
            selectingIndexPaths.insert(indexPath)
        }
        
        self.selectingIndexPaths.accept(selectingIndexPaths)
    }
    
    func selectingIndexPath() -> Observable<(Bool, Set<IndexPath>)> {
        let observer = Observable.combineLatest(selectingAll, selectingIndexPaths)
        return observer
    }
    
    func selectingAny() -> Observable<Bool> {
        return Observable.combineLatest(selectingAll, selectingIndexPaths)
            .map({$0 || !$1.isEmpty})
    }
    
    func selectingContent() -> [[String: Any]] {
        
//        return selectingItems().compactMap({QRDecoder.decode($0.code)?.content})
        return []
        
    }
    
    func selectingItems() -> [RLMScanHistory] {
        
        var selectingItems: [RLMScanHistory] = []
        
        if selectingAll.value {
            selectingItems.append(contentsOf: items)
        } else {
            let items = selectingIndexPaths.value.compactMap({objectForIndexPath($0)})
            selectingItems.append(contentsOf: items)
        }
        
        return selectingItems
    }
    
    func deleteItem(at indexPath: IndexPath) {
        shouldShowAccessory.accept(nil)
        guard let item = objectForIndexPath(indexPath) else { return }
        let realm = try! Realm()
        try! realm.write {
            realm.delete(item)
        }
    }
    
    func deleteSelectingItems() {
        shouldShowAccessory.accept(nil)
        let realm = try! Realm()
        try! realm.write {
            realm.delete(selectingItems())
        }
    }
    
    func markAllAsSeen() {
        let realm = try! Realm()
        let newItems = items.filter("isNew = true")
        if newItems.isEmpty { return }
        try! realm.write {
            newItems.forEach({$0.isNew = false})
        }
    }
}
