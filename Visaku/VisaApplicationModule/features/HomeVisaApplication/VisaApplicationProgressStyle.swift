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
            Circle()
                .trim(from: 0, to: 0.75)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [Color("primary5").opacity(0.1), Color("primary6").opacity(0.1)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                style: StrokeStyle(lineWidth: 16, lineCap: .round))
                .foregroundColor(Color.primary1)
                .rotationEffect(.degrees(135))
            
            Circle()
                .trim(from: 0, to: 0.75 * configuration.value)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [Color("primary5"), Color("primary6")]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                style: StrokeStyle(lineWidth: 16, lineCap: .round))
                .foregroundColor(.blue)
                .rotationEffect(.degrees(135))
            
            
            VStack {
                configuration.currentValueLabel
                    .font(.system(size: 80, weight: .bold, design: .rounded))
                    .foregroundColor(.gray)
            }
        }
        .frame(width: gaugeSize, height: gaugeSize)
    }
}
