//
//  ErrorStateView.swift
//  EmployeeDirectory
//
//  Created by Akshay Bhandary on 8/13/22.
//

import SwiftUI

struct ErrorStateView: View {
    var body: some View {
      VStack() {
        Text("Something Went Wrong!")
          .font(.largeTitle)
          .foregroundColor(.blue).multilineTextAlignment(.center)
        Text("Pull to Refresh and Try Again")
          .font(.subheadline)
      }
    }
}

struct ErrorStateView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorStateView()
    }
}
