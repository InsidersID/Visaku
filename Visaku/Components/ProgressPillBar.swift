//
//  ProgressPillBar.swift
//  Servisa
//
//  Created by Nur Nisrina on 24/09/24.
//

import SwiftUI

struct ProgressPillBar: View {
    let currentPage: Int
    
    var body: some View {
        HStack(spacing: 20) {
            ForEach(1..<5) { i in
                Rectangle()
                    .cornerRadius(25)
                    .frame(width: 70, height: 13)
                    .foregroundStyle(i == currentPage ? .red : Color(" pillBarGrey"))
                
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    ProgressPillBar(currentPage: 1)
}
