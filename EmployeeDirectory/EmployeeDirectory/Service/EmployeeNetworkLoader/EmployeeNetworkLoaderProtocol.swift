//
//  EmployeeNetworkLoader.swift
//  Employee Directory
//
//  Created by Akshay Bhandary on 8/13/22.
//

import Foundation

enum EmployeeLoaderNetworkError: Error {
  case unknown
  case noData
  case badURL
  case networkError
  case decodingError
}

protocol EmployeeNetworkLoaderProtocol {
  func queryForEmployees() async -> Result<EmployeesList, EmployeeLoaderNetworkError>
}
