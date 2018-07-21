//
//  ViewController.swift
//  AyantechNetworkingLibraryDemo
//
//  Created by Sepehr Behroozi on 7/21/18.
//  Copyright © 2018 Ayantech. All rights reserved.
//

import UIKit
import AyanTechNetworkingLibrary

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction private func sendButtonPressed() {
        let params: JSONObject = [
            "Parameters": [
                "LicenseNumber": "12345678",
                "TraceNumber": "123"
            ]
        ]
        let request = ATRequest.request(url: "https://core.inquiry.ayantech.ir/WebServices/App.svc/GetDrivingNegativePointInquirySource", method: .post)
//        request.setJsonBody(body: params)
        request.send {
            print($0.responseString ?? "null")
        }
    }
}

