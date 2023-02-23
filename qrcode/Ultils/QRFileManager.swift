//
//  QRFileManager.swift
//  qrcode
//
//  Created by Quang Tran on 2/8/21.
//

import Foundation

class QRFileManager {
    static let shared = QRFileManager()
    
    let root: URL = {
        let appname = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? "AppData"
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(appname)
    }()
    
    private init() {
        createRootFolderIfNeeded()
    }
    
    private func createRootFolderIfNeeded() {
        let manager = FileManager.default
        if !manager.fileExists(atPath: root.path) {
            try? manager.createDirectory(at: root, withIntermediateDirectories: true, attributes: nil)
        }
        #if DEBUG
        print(root)
        #endif
    }
    
    static var temporaryDirectory: URL {
        return FileManager.default.temporaryDirectory
    }

}
