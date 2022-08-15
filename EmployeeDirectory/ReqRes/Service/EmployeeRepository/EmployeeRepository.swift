//
//  EmployeeRepository.swift
//  EmployeeDirectory
//
//  Created by Akshay Bhandary on 8/13/22.
//

import Foundation
import Combine

private let TAG = "EmployeeRepository"

// This module is meant to be the 'source of truth' and can be updated to
// include a data store fetch from data store while data is fetched from the network
final class EmployeeRepository : EmployeeRepositoryProtocol {
  
  let networkLoader: EmployeeNetworkLoaderProtocol

  init(networkLoader: EmployeeNetworkLoaderProtocol) {
    self.networkLoader = networkLoader
  }
  
  func queryForEmployees() async -> Result<EmployeesList, EmployeeRepositoryError> {

    Log.verbose(TAG,"running query for employees")
    
    // async fetch from network and update and notify
    let result = await networkLoader.queryForEmployees()
    switch (result) {
    case .success(let response):
      return .success(response)
    case .failure(let error):
      Log.error(TAG, error)
      return .failure(map(networkError: error))
    }
  }
  
  private func map(networkError: EmployeeLoaderNetworkError) -> EmployeeRepositoryError {
    switch (networkError) {
    case .unknown:
      return .unknown
    case .networkError:
      return .networkError
    case .decodingError:
      return .decodingError
    case .badURL:
      return .badURL
    case .noData:
      return .noData
    }
  }
}
