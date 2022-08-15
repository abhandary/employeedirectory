//
//  EmptyStateView.swift
//  EmployeeDirectory
//
//  Created by Akshay Bhandary on 8/14/22.
//

import Foundation
import SwiftUI


struct EmptyStateView: View {
    var body: some View {
      VStack() {
        Text("No Employees Found")
          .font(.largeTitle)
          .foregroundColor(.blue).multilineTextAlignment(.center)
        Text("Pull to Refresh and Try Again")
          .font(.subheadline)
      }
    }
}

struct EmptyStateViewView_Previews: PreviewProvider {
    static var previews: some View {
      EmptyStateView()
    }
}
