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
        let request = ATRequest.request(url: "http://localhost:3000/api/game/start", method: .get)
        request.send { res in
            print(res.responseString ?? "null")
        }
        doWithDelay(2.0) {
            request.cancel()
        }
    }
}


func doWithDelay(_ delay: Double, closure:@escaping () -> Void) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}
