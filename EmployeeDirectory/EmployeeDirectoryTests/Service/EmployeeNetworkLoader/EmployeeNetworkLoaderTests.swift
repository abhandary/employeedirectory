//
//  EmployeeNetworkLoaderTest.swift
//  EmployeeDirectoryTests
//
//  Created by Akshay Bhandary on 8/14/22.
//

import XCTest
@testable import EmployeeDirectory

enum MockNetworkError : Error {
  case someError
}

struct SomeCodable : Codable {
  
}

class EmployeeNetworkLoaderTests: XCTestCase {
  
  func testNetworkError() async throws {
    // setup networkloader for this test
    let mockURLSession = MockURLSession(dataToReturn: nil,
                                        responseToReturn: nil,
                                        errorToThrow: MockNetworkError.someError)
    let networkLoader = EmployeeNetworkLoader(session: mockURLSession)
    
    // run query
    let result = await networkLoader.queryForEmployees()
    
    // verify result
    switch (result) {
    case .success(let list):
      XCTFail("expected failure and got success with list - \(list)")
    case .failure(let errorResult):
      XCTAssertEqual(errorResult, .networkError)
    }
  }
  
  func testBadURLError() async throws {
    // setup networkloader for this test
    let mockURLSession = MockURLSession(dataToReturn: nil,
                                        responseToReturn: nil,
                                        errorToThrow: nil)
    let networkLoader = EmployeeNetworkLoader(session: mockURLSession, endpoint: "no such url")
    
    // run query
    let result = await networkLoader.queryForEmployees()
    
    // verify result
    switch (result) {
    case .success(let list):
      XCTFail("expected failure and got success with list - \(list)")
    case .failure(let errorResult):
      XCTAssertEqual(errorResult,.badURL)
    }
  }
  
  func testSuccess() async throws {
    // setup networkloader for this test
    let employeeList = EmployeeDirectoryTestUtils.getRandomEmployeeList(count: 10)
    let data = try! JSONEncoder().encode(employeeList)
    let mockURLSession = MockURLSession(dataToReturn: data,
                                        responseToReturn: URLResponse(),
                                        errorToThrow: nil)
    let networkLoader = EmployeeNetworkLoader(session: mockURLSession)
    
    // run query
    let result = await networkLoader.queryForEmployees()
    
    // verify result
    switch (result) {
    case .success(let list):
      XCTAssertEqual(list, employeeList)
    case .failure(let errorResult):
      XCTFail("unexpected error \(errorResult)")
    }
  }
  
  func testDecodingError() async throws {
    // setup networkloader for this test
    let someCodable = SomeCodable()
    let data = try! JSONEncoder().encode(someCodable)
    let mockURLSession = MockURLSession(dataToReturn: data,
                                        responseToReturn: URLResponse(),
                                        errorToThrow: nil)
    let networkLoader = EmployeeNetworkLoader(session: mockURLSession)
    
    // run query
    let result = await networkLoader.queryForEmployees()
    
    // verify result
    switch (result) {
    case .success(let list):
      XCTFail("expected failure and got success with list - \(list)")
    case .failure(let errorResult):
      XCTAssertEqual(errorResult, .decodingError)
    }
  }
}
