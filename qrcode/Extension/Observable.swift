//
//  Observable.swift
//  qrcode
//
//  Created by Quang Tran on 2/9/21.
//

import Foundation
import RxSwift

extension ObservableType {
    
    func withPrevious() -> Observable<(Element?, Element)> {
        return scan([], accumulator: { (previous, current) in
            Array(previous + [current]).suffix(2)
        })
        .map({ (arr) -> (previous: Element?, current: Element) in
            (arr.count > 1 ? arr.first : nil, arr.last!)
        })
    }
}
