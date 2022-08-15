//
//  EmployeeRepositoryTest.swift
//  EmployeeDirectoryTests
//
//  Created by Akshay Bhandary on 8/14/22.
//

import XCTest

@testable import EmployeeDirectory

class EmployeeRepositoryTests: XCTestCase {

  // employee repo is a passthrough module for now, till data store is incorporated,
  // so doing a basic singular success and error test for now
    
  func testSuccess() async throws {
    
    // setup networkloader for this test
    let employeeList = EmployeeDirectoryTestUtils.getRandomEmployeeList(count: 10)
    let mockNetworkLoader = MockEmployeeNetworkLoader(employeeList: employeeList)
    let repository = EmployeeRepository(networkLoader: mockNetworkLoader)
    
    // run query
    let result = await repository.queryForEmployees()
    
    // verify result
    switch (result) {
    case .success(let list):
      XCTAssertEqual(list, employeeList)
    case .failure(let errorResult):
      XCTFail("unexpected error \(errorResult)")
    }
  }
  
  func testError() async throws {
    // setup networkloader for this test
    let employeeList = EmployeeDirectoryTestUtils.getRandomEmployeeList(count: 10)
    let mockNetworkLoader = MockEmployeeNetworkLoader(employeeList: employeeList, error: .decodingError)
    let repository = EmployeeRepository(networkLoader: mockNetworkLoader)

    // run query
    let result = await repository.queryForEmployees()
    
    // verify result
    switch (result) {
    case .success(let list):
      XCTFail("expected failure and got success with list - \(list)")
    case .failure(let errorResult):
      XCTAssertEqual(errorResult, .decodingError)
    }
  }
}
