//
//  EmployeeRepositoryProtocol.swift
//  EmployeeDirectory
//
//  Created by Akshay Bhandary on 8/13/22.
//

import Foundation
import Combine

enum EmployeeRepositoryError: Error {
  case unknown
  case badURL
  case networkError
  case decodingError
  case noData
}

protocol EmployeeRepositoryProtocol {
  func queryForEmployees() async -> Result<EmployeesList, EmployeeRepositoryError>
}
