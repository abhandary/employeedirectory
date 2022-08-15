//
//  MockEmployeeRepository.swift
//  EmployeeDirectory
//
//  Created by Akshay Bhandary on 8/14/22.
//

import Foundation

@testable import EmployeeDirectory

struct MockEmployeeRepository: EmployeeRepositoryProtocol {
  
  let employeeList: EmployeesList
  var error: EmployeeRepositoryError? = nil
  
  func queryForEmployees() async -> Result<EmployeesList, EmployeeRepositoryError> {
    if let error = error {
      return .failure(error)
    }
    return .success(employeeList)
  }
}
