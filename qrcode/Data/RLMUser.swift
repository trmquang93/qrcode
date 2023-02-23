//
//  RLMUser.swift
//  qrcode
//
//  Created by Quang Tran on 2/6/21.
//

import Foundation
import RealmSwift


class RLMUser: Object {
    @objc dynamic var expirationSubscriptionDate: Date?
    @objc dynamic var lifeTimePurchased: Bool = false
    @objc dynamic var bananhtho: Bool = false
    let invitedFriends = List<String>()
    
    static var current: RLMUser {
        var user: RLMUser
        let realm = try! Realm()
        if let firstUser = realm.objects(RLMUser.self).first {
            user = firstUser
        }
        else {
            let newUser = RLMUser()
            try! realm.write {
                realm.add(newUser)
            }
            user = newUser
        }
        return user
    }
}


// MARK: - Get-only
extension RLMUser {
    var isPuchased: Bool  {
        if bananhtho { return true }
        guard let date = expirationSubscriptionDate else { return lifeTimePurchased }
        let compareResult = date.compare(Date())
        return  compareResult == .orderedDescending || compareResult == .orderedSame || lifeTimePurchased
    }
}

