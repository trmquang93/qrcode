//
//  AutoGenerateProtocols.swift
//  EthereumMonitoring
//
//  Created by Tran Minh Quang on 15/11/2017.
//  Copyright © 2017 Tran Minh Quang. All rights reserved.
//

import UIKit

protocol CellAutoCreateViews {
    func setupViews()
    func createConstraints()
}

protocol ViewControllerAutoCreateViews {
    func setupViews()
    func createConstraints()
}

protocol AutoCreateViews {
    func setupViews()
    func createConstraints()
}

public protocol AutoMapping {
    
}
