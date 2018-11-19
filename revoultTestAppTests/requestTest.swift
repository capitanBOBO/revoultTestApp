//
//  requestTest.swift
//  revoultTestAppTests
//
//  Created by Иван Савин on 19/11/2018.
//  Copyright © 2018 Иван Савин. All rights reserved.
//

import XCTest

class requestTest: XCTestCase {

    var sessionUnderTest:URLSession!
    
    override func setUp() {
        super.setUp()
        sessionUnderTest = URLSession(configuration: URLSessionConfiguration.default)
    }

    override func tearDown() {
        sessionUnderTest = nil
        super.tearDown()
    }

    func testMainRequest() {
        let request = URLRequest(url: URL(string: "https://revolut.duckdns.org/latest?base=EUR")!)
        let promise = expectation(description: "Successfull request")
        let dataTask = sessionUnderTest.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                XCTFail("Bad request with error: \(String(describing: error?.localizedDescription))")
                return
            }
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    promise.fulfill()
                } else {
                    XCTFail("Bad request with status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()
        wait(for: [promise], timeout: 10)
    }
    
    
}
