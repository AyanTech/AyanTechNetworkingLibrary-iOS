//
//  ViewController.swift
//  AyantechNetworkingLibraryDemo
//
//  Created by Sepehr Behroozi on 7/21/18.
//  Copyright © 2018 Ayantech. All rights reserved.
//

import AyanTechNetworkingLibrary
import Combine
import UIKit

class ViewController: UIViewController {
    private let apiURL = "YOUR_URL"
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction private func sendButtonPressed() {
        // MARK: - Callback (deprecated)

        let request = ATRequest.request(url: apiURL, method: .get)

        request.send { res in
            print("Callback response:", res.responseString ?? "null")
        }
        doWithDelay(2.0) {
            request.cancel()
        }

        // MARK: - Async/await

        Task {
            let request = ATRequest.request(url: apiURL, method: .post)
            let response = await request.send()
            await MainActor.run {
                print("Async/await response:", response.responseString ?? "null")
            }
        }

        // MARK: - Combine

        let combineRequest = ATRequest.request(url: apiURL, method: .post)
        combineRequest.responsePublisher()
            .receive(on: DispatchQueue.main)
            .sink { response in
                if let error = response.error {
                    print("Combine responsePublisher error:", String(describing: error.type))
                    return
                }
                print("Combine responsePublisher:", response.responseString ?? "null")
            }
            .store(in: &cancellables)

        combineRequest.valuePublisher()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("Combine valuePublisher failure:", String(describing: error.type))
                    }
                },
                receiveValue: { response in
                    print("Combine valuePublisher:", response.responseString ?? "null")
                }
            )
            .store(in: &cancellables)
    }
}

func doWithDelay(_ delay: Double, closure: @Sendable @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure
    )
}
