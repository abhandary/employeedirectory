//
//  Employee.swift
//  Employee Directory
//
//  Created by Akshay Bhandary on 8/13/22.
//

import Foundation

struct Employee: Codable, Identifiable, Equatable {
  let id : UUID
  let fullName: String
  let phoneNumber: String
  let emailAddress: String
  let photoUrlSmall: String
  let photoUrlLarge: String
  let biography: String
  let team: String
  let employeeType: String
  
  enum CodingKeys: String, CodingKey {
    case fullName, phoneNumber, emailAddress, photoUrlSmall, photoUrlLarge, biography, team, employeeType
    case id = "uuid"
  }
}
