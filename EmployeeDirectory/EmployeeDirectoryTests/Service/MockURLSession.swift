//
//  MockURLSession.swift
//  EmployeeDirectory
//
//  Created by Akshay Bhandary on 8/14/22.
//

import Foundation
import UIKit

class MockURLSession: URLSessionProtocol {
  
  var dataToReturn: Data?
  var responseToReturn: URLResponse?
  var errorToThrow: Error?
  
  init(dataToReturn: Data?, responseToReturn: URLResponse?, errorToThrow: Error? = nil) {
    self.dataToReturn = dataToReturn
    self.responseToReturn = responseToReturn
    self.errorToThrow = errorToThrow
  }
  
  func data(from url: URL, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
    if let errorToThrow = errorToThrow {
      throw errorToThrow
    }
    if let dataToReturn = self.dataToReturn, let responseToReturn = responseToReturn {
      return (dataToReturn, responseToReturn)
    }
    throw fatalError("expecting non-nil data response and response to return if error is not set")
  }
}
