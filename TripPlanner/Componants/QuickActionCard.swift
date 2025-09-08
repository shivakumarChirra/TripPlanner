//
//  QuickActionCard.swift
//  TripPlanner
//
//  Created by shivakumar chirra on 07/09/25.
//

import SwiftUI

struct QuickActionCard: View {
    var icon: String
    var title: String
    var subtitle: String
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(.white)
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            Text(subtitle)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity, minHeight: 120)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .shadow(radius: 4)
    }
}

#Preview {
    QuickActionCard(icon: "", title: "", subtitle: "")
}


extension Text {
    func formLabel() -> some View {
        self.font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(.white.opacity(0.8))
            .padding(.bottom, 2)
    }
}
