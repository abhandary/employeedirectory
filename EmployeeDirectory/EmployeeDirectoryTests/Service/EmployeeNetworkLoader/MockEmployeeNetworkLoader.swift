//
//  MockEmployeeNetworkLoader.swift
//  EmployeeDirectory
//
//  Created by Akshay Bhandary on 8/14/22.
//

import Foundation

struct MockEmployeeNetworkLoader: EmployeeNetworkLoaderProtocol {
  
  let employeeList: EmployeesList
  var error: EmployeeLoaderNetworkError? = nil
  
  func queryForEmployees() async -> Result<EmployeesList, EmployeeLoaderNetworkError> {
    if let error = error {
      return .failure(error)
    }
    return .success(employeeList)
  }
}
