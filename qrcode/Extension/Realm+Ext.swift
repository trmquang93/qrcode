//
//  Realm+Ext.swift
//  qrcode
//
//  Created by Quang Tran on 2/7/21.
//

import Foundation
import RealmSwift

extension Realm {
    static var realm: Realm {
        return try! Realm()
    }
    
    static func config() {
        let config = Realm.Configuration(
        // Set the new schema version. This must be greater than the previously used
        // version (if you've never set a schema version before, the version is 0).
        schemaVersion: 0,

        // Set the block which will be called automatically when opening a Realm with
        // a schema version lower than the one set above
        migrationBlock: { migration, oldSchemaVersion in
            // We haven’t migrated anything yet, so oldSchemaVersion == 0
            if (oldSchemaVersion < 1) {
                // Nothing to do!
                // Realm will automatically detect new properties and removed properties
                // And will update the schema on disk automatically
            }
        })
        
        Realm.Configuration.defaultConfiguration = config
        
        while (try? Realm()) == nil {
            Realm.Configuration.defaultConfiguration.schemaVersion += 1
        }
        
        // Tell Realm to use this new configuration object for the default Realm
        

        // Now that we've told Realm how to handle the schema change, opening the file
        // will automatically perform the migration
        #if DEBUG
        print(Realm.realm.configuration.fileURL?.absoluteString as Any)
        #endif
    }
}
