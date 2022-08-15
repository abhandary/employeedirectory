//
//  EmployeeListViewController.swift
//  Employee Directory
//
//  Created by Akshay Bhandary on 8/13/22.
//

import UIKit
import Combine
import SwiftUI

private let REQ_USER_CELL_HOW_HEIGHT = 100.0
private let TAG = "EmployeeListViewController"

@MainActor class EmployeeListViewController: UIViewController  {
  
  var cancellables: Set<AnyCancellable> = []
  
  var diffableDataSource: UITableViewDiffableDataSource<EmployeesTableSection, Employee.ID>?
  
  var emptyViewController: UIViewController?
  var initialViewController: UIViewController?
  var errorViewController: UIViewController?
  let tableView: UITableView!
  let viewModel: EmployeeListViewModel!
  let assetStore: AssetStore!
  
  init(viewModel: EmployeeListViewModel, assetStore: AssetStore) {
    self.viewModel = viewModel
    self.assetStore = assetStore
    self.tableView = UITableView()
    super.init(nibName: nil, bundle: nil)
  }
  
  // This is also necessary when extending the superclass.
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    setupTableView()
    setupTableViewDataSource()
    NSLayoutConstraint.activate(staticConstraints())
    showInitialState()
    setupViewModel()
  }
  
  private func staticConstraints() -> [NSLayoutConstraint] {
    var constraints: [NSLayoutConstraint] = []
    
    // name label constraints
    constraints.append(contentsOf:[
      tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
    ])
    
    return constraints
  }
  
  private func setupViewModel() {
    Task {
      await viewModel.$employees
        .receive(on: RunLoop.main)
        .sink { employees in self.employeesUpdated(employees: employees)
        }.store(in: &cancellables)
      await viewModel.queryForEmployees()
    }
  }
  
  private func employeesUpdated(employees: [Employee]) {
    
    if viewModel.employeeListState == .error {
      self.tableView.refreshControl?.endRefreshing()
      showErrorState()
      return
    } else if employees.count == 0 && viewModel.employeeListState == .loaded {
      self.tableView.refreshControl?.endRefreshing()
      showEmptyState()
      return
    } else {
      removeErrorView()
      removeInitialView()
      removeEmptyView()
    }
    
    self.tableView.refreshControl?.endRefreshing()
    
    var snapshot = NSDiffableDataSourceSnapshot<EmployeesTableSection, Employee.ID>()
    snapshot.appendSections([.main])
    let employeeIDs = employees.map { $0.id }
    snapshot.appendItems(employeeIDs, toSection:.main)
    self.diffableDataSource?.apply(snapshot, animatingDifferences: true)
  }
}

// MARK: - UITableView Delegate
extension EmployeeListViewController: UITableViewDelegate {
  private func setupTableView() {
    self.tableView.delegate = self
    self.tableView.register(EmployeeTableViewCell.self,
                            forCellReuseIdentifier: EmployeeTableViewCell.cellReuseIdentifier)
    self.tableView.rowHeight = 100.0
    self.tableView.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(self.tableView)
    self.tableView.refreshControl = UIRefreshControl()
    self.tableView.refreshControl?.addTarget(self, action:
                                              #selector(handleRefreshControl),
                                              for: .valueChanged)
  }
  
  @objc func handleRefreshControl() {
    Task {
      await viewModel.queryForEmployees()
    }
  }
}

// MARK: - error state and initial state
extension EmployeeListViewController {
  private func showErrorState() {
    if errorViewController == nil {
      errorViewController = UIHostingController(rootView: ErrorStateView())
      let color = UIColor(red: 0.129317, green: 0.825341, blue: 0.479609, alpha: 1.0)
      errorViewController?.view.backgroundColor = color
    }
    guard let errorViewController = errorViewController else {
      return
    }
    self.tableView.addSubview(errorViewController.view)
    errorViewController.view.frame = self.view.frame
  }
  
  private func removeErrorView() {
    errorViewController?.view.removeFromSuperview()
  }
  
  private func showInitialState() {
    if initialViewController == nil {
      initialViewController = UIHostingController(rootView: InitialStateView())
      let color = UIColor(red: 0.129317, green: 0.825341, blue: 0.479609, alpha: 0.9)
      initialViewController?.view.backgroundColor = color
    }
    guard let initialViewController = initialViewController else {
      return
    }
    self.tableView.addSubview(initialViewController.view)
    initialViewController.view.frame = self.view.frame
  }
  
  private func removeInitialView() {
    initialViewController?.view.removeFromSuperview()
  }
  
  private func showEmptyState() {
    if emptyViewController == nil {
      emptyViewController = UIHostingController(rootView: EmptyStateView())
      let color = UIColor.random()
      emptyViewController?.view.backgroundColor = color
    }
    guard let emptyViewController = emptyViewController else {
      return
    }
    self.tableView.addSubview(emptyViewController.view)
    emptyViewController.view.frame = self.view.frame
  }
  
  func removeEmptyView() {
    emptyViewController?.view.removeFromSuperview()
  }
}


// MARK: - table view data source
extension EmployeeListViewController
{
  func setupTableViewDataSource() {
    
    diffableDataSource
    = UITableViewDiffableDataSource<EmployeesTableSection, Employee.ID>(tableView: tableView) { [weak self]
        (tableView, indexPath, employeeID) -> UITableViewCell? in
      guard let strongSelf = self else {
        return nil
      }
      let employee = strongSelf.viewModel.employees.first { $0.id == employeeID }
      guard let employee = employee else {
        Log.error("unable to find employee object that matches id - \(employeeID)")
        return UITableViewCell()
      }
      guard
        let cell = tableView.dequeueReusableCell(withIdentifier: EmployeeTableViewCell.cellReuseIdentifier, for: indexPath) as? EmployeeTableViewCell
      else {
        Log.error(TAG, "unable to dequeue cell")
        return UITableViewCell()
      }
      
      cell.setup(withEmployee: employee, assetStore: strongSelf.assetStore)
      
      return cell
    }
  }
}

