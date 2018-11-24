//
//  NetworkManagerTest.swift
//  revoultTestAppTests
//
//  Created by Иван Савин on 24/11/2018.
//  Copyright © 2018 Иван Савин. All rights reserved.
//

import XCTest
@testable import revoultTestApp

class NetworkManagerTest: XCTestCase {
    
    var networkManager:NetworkManager!
    
    override func setUp() {
        networkManager = NetworkManager()
    }
    
    override func tearDown() {
        networkManager = nil
    }
    
    func testNetworkManagerLoadData() {
        let promise = expectation(description: "Success")
        networkManager.loadData(forCurrency: "EUR", success: { (result) in
            if !result.isEmpty {
                promise.fulfill()
            } else {
                XCTFail("Empty result dictionary")
            }
        }) { (error) in
            XCTFail(error.localizedDescription)
        }
        wait(for: [promise], timeout: 10)
    }
    
}
