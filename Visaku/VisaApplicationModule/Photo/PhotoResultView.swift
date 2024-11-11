//
//  PhotoResultView.swift
//  VisaApplicationModule
//
//  Created by Lonard Steven on 18/10/24.
//

import Foundation
import SwiftUI
import UIComponentModule

public struct PhotoResultView: View {
    var image: Image?
    
    public init(image: Image?) {
        
    }
    
    public var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    if let image {
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 320, height: 600)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .padding()
                    } else {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.gray)
                            .frame(width: 300, height: 300)
                            .overlay {
                                VStack {
                                    Image(systemName: "photo.badge.exclamationmark")
                                        .font(.largeTitle)
                                        .foregroundColor(.white)
                                    
                                    Text("Fotomu sepertinya dalam masalah...")
                                        .font(.title)
                                        .foregroundColor(.white)
                                }
                            }
                    }
                    
                    Text("Diupload \(Date().formatted(date: .abbreviated, time: .omitted))")
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding()
                    
                    Spacer()
                    
                    CustomButton(text: "Simpan", textColor: Color.white, color: Color.blue, fontSize: 12, cornerRadius: 14, paddingHorizontal: 16, paddingVertical: 15) {
                        return
                    }

                    CustomButton(text: "Foto ulang", textColor: Color.blue, color: Color.blue.opacity(0), fontSize: 12, cornerRadius: 14, paddingHorizontal: 16, paddingVertical: 15) {
                        return
                    }
                    
                }
                
            }
            .navigationTitle("Foto")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
