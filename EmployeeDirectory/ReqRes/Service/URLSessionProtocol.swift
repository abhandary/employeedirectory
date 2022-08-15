//
//  URLSessionProtocol.swift
//  EmployeeDirectory
//
//  Created by Akshay Bhandary on 8/14/22.
//

import Foundation

protocol URLSessionProtocol {
  func data(from url: URL, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
}

extension URLSession : URLSessionProtocol {}
