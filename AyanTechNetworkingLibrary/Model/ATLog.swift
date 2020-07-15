//
//  RJLog.swift
//  Raja
//
//  Created by Sepehr Behroozi on 6/23/18.
//  Copyright © 2018 Ayantech. All rights reserved.
//

import Foundation

var verbose = true

func ATLog(_ key: String, logData: Any?) {
    guard verbose else {
        return
    }
    if let logData = logData {
        let logContent = "AT-Log-\(key) ===>  \(logData)"
        print(logContent)
    }
}
