//
//  String+Regex.swift
//  qrcode
//
//  Created by Quang Tran on 2/7/21.
//

import Foundation

extension String {
    func matched(regexString: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: regexString)
        else {return false }
        let range = NSRange(location: 0, length: count)
        
        return regex.firstMatch(in: self, options: [], range: range) != nil
    }
    
    func firstMatch(for regex: String) -> String? {
        guard let regex = try? NSRegularExpression(pattern: regex)
        else {return nil }
        let range = NSRange(location: 0, length: count)
        
        let results = regex.firstMatch(in: self,
                                    range: range)
        
        return results.map {
            String(self[Range($0.range, in: self)!])
        }
    }
}
