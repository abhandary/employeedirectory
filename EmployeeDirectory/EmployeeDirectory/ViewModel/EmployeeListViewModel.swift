//
//  EmployeeListViewModel.swift
//  Employee Directory
//
//  Created by Akshay Bhandary on 8/13/22.
//

import Foundation
import Combine

private let TAG = "EmployeeListViewModel"

enum EmployeeListState {
  case initial
  case loaded
  case error
}

actor EmployeeListViewModel {

  @Published @MainActor var employees:[Employee] = []
  @MainActor var employeeListState: EmployeeListState
  
  private var queryTask: Task<Optional<()>, Never>?
  private let repository: EmployeeRepositoryProtocol
  
  init(repository: EmployeeRepositoryProtocol) {
    self.employeeListState = .initial
    self.repository = repository
  }
  
  func queryForEmployees() {
    queryTask?.cancel()
    queryTask = Task { [weak self] in
      await self?.queryForEmployeesAsync()
    }
  }
  
  func queryForEmployeesAsync() async {
    let result = await self.repository.queryForEmployees()
    switch(result) {
    case .failure(let error):
      Log.error(TAG, error)
      await update(employees: [], state: .error)
    case .success(let employees):
      await update(employees: employees.employees, state: .loaded)
    }
  }
  
  private func update(employees: [Employee], state: EmployeeListState) async {
    let employees = employees.sorted {
      $0.team < $1.team ||
      $0.team == $1.team && $0.fullName < $1.fullName
    }
    await MainActor.run {
      self.employeeListState = state
      self.employees = employees
    }
  }
}
