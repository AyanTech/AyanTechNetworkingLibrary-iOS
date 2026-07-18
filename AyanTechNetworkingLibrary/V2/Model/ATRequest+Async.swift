//
//  ATRequest+Async.swift
//  AyanTechNetworkingLibrary
//

import Foundation

extension ATRequest {
    @available(iOS 13.0, *)
    public func send() async -> ATResponse {
        if let mockFile = self.mockFilePath, !mockFile.isEmpty {
            let responseAndDelay = ATResponse.from(mockFilePath: mockFile)
            try? await Task.sleep(nanoseconds: UInt64(responseAndDelay.1 * 1_000_000_000))
            return responseAndDelay.0
        } else {
            let responseCollection = await Server.sendRequest(req: self)
            let atResponse = ATResponse.from(responseData: responseCollection.0, responseHeaders: responseCollection.1, responseError: responseCollection.2)
            return atResponse
        }
    }
}
