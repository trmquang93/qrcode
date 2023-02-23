//
//  VMMyCode.swift
//  qrcode
//
//  Created by Quang Tran on 2/19/21.
//

import Foundation
import AppStarter
import RealmSwift
import RxSwift
import RxCocoa

class VMMyCode: ASViewModelListData {
    
    var itemIdentifiers: [String : AnyClass] {
        [
            QRHistoryCell.className : QRHistoryCell.self
        ]
    }
    var items: Results<RLMCreatedCode>! = {Realm.realm.objects(RLMCreatedCode.self).sorted(byKeyPath: "date", ascending: false)}()
    
    lazy var isEmpty = Observable.collection(from: items).map({$0.isEmpty})
    let shouldShowAccessory = BehaviorRelay<IndexPath?>(value: nil)
    
    init() {
        observeChanges()
    }
    
    func markAllAsSeen() {
        let realm = try! Realm()
        let newItems = items.filter("isNew = true")
        if newItems.isEmpty { return }
        try! realm.write {
            newItems.forEach({$0.isNew = false})
        }
    }
    
    func deleteItem(at indexPath: IndexPath) {
        shouldShowAccessory.accept(nil)
        guard let item = objectForIndexPath(indexPath) else { return }
        let realm = try! Realm()
        try! realm.write {
            realm.delete(item)
        }
    }
}
