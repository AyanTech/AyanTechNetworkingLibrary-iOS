//
//  JSONObject.swift
//  AyanTechNetworkingLibrary
//
//  Created by Sepehr Behroozi on 8/11/18.
//  Copyright © 2018 Ayantech. All rights reserved.
//

import Foundation

extension Dictionary where Key == String {
    func toJsonData() -> Data {
        var result = Data()
        do {
         result = try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
        } catch {
            
        }
        return result
    }
}
