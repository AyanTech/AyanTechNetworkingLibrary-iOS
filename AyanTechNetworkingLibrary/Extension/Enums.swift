//
//  Enums.swift
//  InquirySDKLib
//
//  Created by Sepehr Behroozi on 6/26/18.
//  Copyright © 2018 Ayantech. All rights reserved.
//

import Foundation

extension URLError.Code {
    var name: String {
        switch self {
        case URLError.Code.appTransportSecurityRequiresSecureConnection:
            return "appTransportSecurityRequiresSecureConnection"
        case URLError.Code.backgroundSessionInUseByAnotherProcess:
            return "backgroundSessionInUseByAnotherProcess"
        case URLError.Code.backgroundSessionRequiresSharedContainer:
            return "backgroundSessionRequiresSharedContainer"
        case URLError.Code.backgroundSessionWasDisconnected:
            return "backgroundSessionWasDisconnected"
        case URLError.Code.badServerResponse:
            return "badServerResponse"
        case URLError.Code.badURL:
            return "badURL"
        case URLError.Code.callIsActive:
            return "callIsActive"
        case URLError.Code.cancelled:
            return "cancelled"
        case URLError.Code.cannotCloseFile:
            return "cannotCloseFile"
        case URLError.Code.cannotConnectToHost:
            return "cannotConnectToHost"
        case URLError.Code.cannotCreateFile:
            return "cannotCreateFile"
        case URLError.Code.cannotDecodeContentData:
            return "cannotDecodeContentData"
        case URLError.Code.cannotDecodeRawData:
            return "cannotDecodeRawData"
        case URLError.Code.cannotFindHost:
            return "cannotFindHost"
        case URLError.Code.cannotLoadFromNetwork:
            return "cannotLoadFromNetwork"
        case URLError.Code.cannotMoveFile:
            return "cannotMoveFile"
        case URLError.Code.cannotOpenFile:
            return "cannotOpenFile"
        case URLError.Code.cannotParseResponse:
            return "cannotParseResponse"
        case URLError.Code.cannotRemoveFile:
            return "cannotRemoveFile"
        case URLError.Code.cannotWriteToFile:
            return "cannotWriteToFile"
        case URLError.Code.clientCertificateRejected:
            return "clientCertificateRejected"
        case URLError.Code.clientCertificateRequired:
            return "clientCertificateRequired"
        case URLError.Code.dataLengthExceedsMaximum:
            return "dataLengthExceedsMaximum"
        case URLError.Code.dataNotAllowed:
            return "dataNotAllowed"
        case URLError.Code.dnsLookupFailed:
            return "dnsLookupFailed"
        case URLError.Code.downloadDecodingFailedMidStream:
            return "downloadDecodingFailedMidStream"
        case URLError.Code.downloadDecodingFailedToComplete:
            return "downloadDecodingFailedToComplete"
        case URLError.Code.fileDoesNotExist:
            return "fileDoesNotExist"
        case URLError.Code.httpTooManyRedirects:
            return "httpTooManyRedirects"
        case URLError.Code.internationalRoamingOff:
            return "internationalRoamingOff"
        case URLError.Code.networkConnectionLost:
            return "networkConnectionLost"
        case URLError.Code.noPermissionsToReadFile:
            return "noPermissionsToReadFile"
        case URLError.Code.notConnectedToInternet:
            return "notConnectedToInternet"
        case URLError.Code.redirectToNonExistentLocation:
            return "redirectToNonExistentLocation"
        case URLError.Code.requestBodyStreamExhausted:
            return "requestBodyStreamExhausted"
        case URLError.Code.resourceUnavailable:
            return "resourceUnavailable"
        case URLError.Code.secureConnectionFailed:
            return "secureConnectionFailed"
        case URLError.Code.serverCertificateHasBadDate:
            return "serverCertificateHasBadDate"
        case URLError.Code.serverCertificateHasUnknownRoot:
            return "serverCertificateHasUnknownRoot"
        case URLError.Code.serverCertificateNotYetValid:
            return "serverCertificateNotYetValid"
        case URLError.Code.serverCertificateUntrusted:
            return "serverCertificateUntrusted"
        case URLError.Code.timedOut:
            return "timedOut"
        case URLError.Code.unknown:
            return "unknown"
        case URLError.Code.unsupportedURL:
            return "unsupportedURL"
        case URLError.Code.userAuthenticationRequired:
            return "userAuthenticationRequired"
        case URLError.Code.userCancelledAuthentication:
            return "userCancelledAuthentication"
        case URLError.Code.zeroByteResource:
            return "zeroByteResource"
        default:
            return "default"
        }
    }
}
