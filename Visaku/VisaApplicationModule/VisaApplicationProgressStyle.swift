//
//  VisaApplicationProgressStyle.swift
//  VisaApplicationModule
//
//  Created by hendra on 18/10/24.
//

import SwiftUI

struct VisaApplicationProgressStyle: GaugeStyle {
    var gaugeSize: CGFloat
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            // Trimmed circle with solid color and rounded stroke
            Circle()
                .trim(from: 0, to: 0.75)
                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
                .foregroundColor(.cyan)  // Solid color
                .rotationEffect(.degrees(135))
            
            Circle()
                .trim(from: 0, to: 0.75 * configuration.value)
                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
                .foregroundColor(.blue)  // Solid color
                .rotationEffect(.degrees(135))
            
            
            VStack {
                // Display the current value
                configuration.currentValueLabel
                    .font(.system(size: 80, weight: .bold, design: .rounded))
                    .foregroundColor(.gray)
            }
        }
        .frame(width: gaugeSize, height: gaugeSize)
    }
}
