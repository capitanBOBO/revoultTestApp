//
//  DataManagerTest.swift
//  revoultTestAppTests
//
//  Created by Иван Савин on 24/11/2018.
//  Copyright © 2018 Иван Савин. All rights reserved.
//

import XCTest
@testable import revoultTestApp

class DataManagerTest: XCTestCase, DataManagerDelegate {

    var dataManager:DataManager!
    var promise:XCTestExpectation!
    
    override func setUp() {
        super.setUp()
        dataManager = DataManager()
        dataManager.delegate = self
        promise = expectation(description: "Success")
    }

    override func tearDown() {
        promise = nil
        dataManager = nil
        super.tearDown()
    }
    
    func testDownloadData() {
        dataManager.downloadData()
        wait(for: [promise], timeout: 10)
    }
    
    func testLoadAllCurrency() {
        if let currencies = dataManager.loadCurrency() {
            if !currencies.isEmpty {
                promise.fulfill()
            } else {
                XCTFail("Currency loading failure or empty DB")
            }
        } else {
            XCTFail("Currency loading failure or empty DB")
        }
        
        wait(for: [promise], timeout: 10)
    }
    
    func testLoadCurrencyWithName() {
        if let currency = dataManager.loadCurrency(for: "EUR")?.first {
            if currency.name == "EUR" {
                promise.fulfill()
            } else {
                XCTFail("Incorrect currency was loaded")
            }
        } else {
            XCTFail("Currency loading failure or empty DB")
        }
        wait(for: [promise], timeout: 10)
    }
    
    func testLoadBaseCurrency() {
        if let currency = dataManager.loadBaseCurrency() {
            if currency.isBase {
                promise.fulfill()
            } else {
                XCTFail("Incorrect currency was loaded")
            }
        } else {
            XCTFail("Currency loading failure or empty DB")
        }
        wait(for: [promise], timeout: 10)
    }
    
    func testUpdateBaseCurrencyValue() {
        let checkPromise = expectation(description: "Check success")
        dataManager.updateBaseCurrency(value: 15)
        wait(for: [promise], timeout: 10)
        if let currency = dataManager.loadBaseCurrency() {
            if currency.value == 15 {
                checkPromise.fulfill()
            } else {
                XCTFail("Base currency value wasn't change")
            }
        } else {
            XCTFail("Currency loading failure or empty DB")
        }
        wait(for: [checkPromise], timeout: 10)
    }
    
    func testSetCurrencyAsBase() {
        let checkPromise = expectation(description: "Check success")
        dataManager.setCurrencyAsBase("USD")
        wait(for: [promise], timeout: 10)
        if let currency = dataManager.loadBaseCurrency() {
            XCTAssert(currency.name == "USD", "Base currency wasn't change")
            checkPromise.fulfill()
        } else {
            XCTFail("Currency loading failure or empty DB")
        }
        wait(for: [checkPromise], timeout: 10)
    }
    
    //MARK: DataMAnager delegate
    
    func dataWasUpdated() {
        promise.fulfill()
    }
    
    func dataUpdateError(_ errorDescription: String) {
        XCTFail(errorDescription)
    }
    
}
