//
//  EmployeeDirectoryTestUtils.swift
//  EmployeeDirectoryTests
//
//  Created by Akshay Bhandary on 8/14/22.
//

import Foundation

@testable import EmployeeDirectory

struct EmployeeDirectoryTestUtils {
  static func getRandomEmployee() -> Employee {
    
    return Employee(id: UUID(),
             fullName: "\(arc4random())",
             phoneNumber: "\(arc4random())",
             emailAddress: "\(arc4random())",
             photoUrlSmall: "",
             photoUrlLarge: "",
             biography: "\(arc4random())",
             team: "\(arc4random())",
             employeeType: "\(arc4random())")
  }
  
  static func getRandomEmployeeList(count: Int) -> EmployeesList {
    var employeeList: [Employee] = []
    for _ in 0..<count {
      employeeList.append(getRandomEmployee())
    }
    return EmployeesList(employees: employeeList)
  }
}
