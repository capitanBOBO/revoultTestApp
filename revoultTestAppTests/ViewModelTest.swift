//
//  ViewModelTest.swift
//  revoultTestAppTests
//
//  Created by Ivan Savin on 26/11/2018.
//  Copyright © 2018 Иван Савин. All rights reserved.
//

import XCTest
@testable import revoultTestApp

class ViewModelTest: XCTestCase, ViewModelDelegate {

    var viewModel:ViewModel!
    var promise: XCTestExpectation!
    
    override func setUp() {
        super.setUp()
        viewModel = ViewModel()
        viewModel.delegate = self
        promise = expectation(description: "Success")
    }

    override func tearDown() {
        viewModel = nil
        promise = nil
        super.tearDown()
    }

    func testDataUpdate() {
        viewModel.downloadData()
        wait(for: [promise], timeout: 10)
    }
    
    func testCountOfRows() {
        viewModel.downloadData()
        wait(for: [promise], timeout: 10)
        XCTAssert(viewModel.countOfRows() != 0, "Wrong items count")
    }
    
    func testCellViewModel() {
        viewModel.downloadData()
        wait(for: [promise], timeout: 10)
        if viewModel.cellViewModelFor(IndexPath(row: 0, section: 0)) != nil {
            XCTAssert(true)
        } else {
            XCTFail("Can't get cell viewModel")
        }
    }
    
    func updateCurrenciesListAt(_ indexPaths: [IndexPath]?) {
        promise.fulfill()
    }
    
    func updateError(_ errorDescription: String) {
        XCTFail(errorDescription)
    }
}
