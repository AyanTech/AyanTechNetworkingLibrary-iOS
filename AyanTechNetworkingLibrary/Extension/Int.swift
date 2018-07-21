//
//  Int.swift
//  Raja
//
//  Created by Sepehr Behroozi on 6/9/18.
//  Copyright © 2018 Ayantech. All rights reserved.
//

import Foundation

extension Int {
    func toString() -> String {
        return String(self)
    }
    
    func separateByCharacter(ch: String = "،") -> String {
        var result = ""
        let currentString = "\(self)"
        var counter = 0
        currentString.reversed().forEach {
            result += "\($0)"
            counter += 1
            if (counter % 3 == 0) && counter > 0 && counter < currentString.count {
                result += ch
            }
        }
        return String(result.reversed())
    }
}
