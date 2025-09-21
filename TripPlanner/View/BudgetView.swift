//
//  BudgetView.swift
//  TripPlanner
//
//  Created by shivakumar chirra on 30/06/1947 Saka.
//

import Foundation
import SwiftUI


struct BudgetsView: View {
    var body: some View {
        ZStack {
            LinearGradient(colors: [.green.opacity(0.4), .blue.opacity(0.3)],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack {
                Text("Budgets")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                Spacer()
            }
        }
    }
}
