//
//  InitiateStateView.swift
//  EmployeeDirectory
//
//  Created by Akshay Bhandary on 8/14/22.
//

import SwiftUI

let loadingMessages = [
  "Adjusting Bell Curves...",
  "Aesthesizing Industrial Areas...",
  "Aligning Covariance Matrices...",
  "Applying Feng Shui Shaders...",
  "Applying Theatre Soda Layer...",
  "Asserting Packed Exemplars...",
  "Attempting to Lock Back-Buffer...",
  "Binding Sapling Root System...",
  "Breeding Fauna...",
  "Building Data Trees...",
  "Bureacritizing Bureaucracies...",
  "Calculating Inverse Probability Matrices...",
  "Calculating Llama Expectoration Trajectory...",
  "Calibrating Blue Skies...",
  "Charging Ozone Layer...",
  "Coalescing Cloud Formations...",
  "Cohorting Exemplars...",
  "Collecting Meteor Particles...",
  "Compounding Inert Tessellations...",
  "Compressing Fish Files...",
  "Computing Optimal Bin Packing...",
  "Concatenating Sub-Contractors...",
  "Containing Existential Buffer...",
  "Debarking Ark Ramp...",
  "Debunching Unionized Commercial Services...",
]

struct InitialStateView: View {
  
  var body: some View {
    VStack() {
      Text("Loading Employee Directory!")
        .font(.largeTitle)
        .foregroundColor(.blue).multilineTextAlignment(.center)
      Text(loadingMessages[Int(arc4random()) % loadingMessages.count])
        .font(.subheadline)
    }
  }
}

struct InitialStateView_Previews: PreviewProvider {
    static var previews: some View {
      InitialStateView()
    }
}
