//
//  EmployeeNetworkLoader.swift
//  Employee Directory
//
//  Created by Akshay Bhandary on 8/13/22.
//

import Foundation

private let TAG = "EmployeeNetworkLoader"

struct EmployeeNetworkLoader: EmployeeNetworkLoaderProtocol {

  let session: URLSessionProtocol
  let endpoint: String
  
  init(session: URLSessionProtocol = URLSession.shared,
       endpoint: String = "https://s3.amazonaws.com/sq-mobile-interview/employees.json") {
    self.session = session
    self.endpoint = endpoint
  }
  
  func queryForEmployees() async -> Result<EmployeesList, EmployeeLoaderNetworkError> {

    Log.verbose(TAG, "querying for employees")
    guard let endpointURL = URL(string: endpoint) else {
      Log.error(TAG, "endpoint URL is invalid, unable to run a query!")
      return .failure(.badURL)
    }
    Log.verbose(TAG, "queryForEmployees: hitting endpoint URL - \(endpointURL)")
    
    var data: Data?
    do {
      (data, _) = try await self.session.data(from: endpointURL, delegate: nil)
    }
    catch {
      Log.error(TAG, "queryForEmployees: Network request failed - \(error)")
      return .failure(.networkError)
    }
    
    guard let  data = data else {
      Log.error(TAG, "queryForEmployees: unexpected nil data")
      return .failure(.noData)
    }
    
    do {
      Log.verbose(TAG, data)
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      let response = try decoder.decode(EmployeesList.self, from: data)
      Log.verbose(TAG, "queryForEmployees: Success, got a response")
      return .success(response)
    }
    catch {
      print("queryForEmployees: Network request decoding failed - \(error)")
      return .failure(.decodingError)
    }
  }
}
