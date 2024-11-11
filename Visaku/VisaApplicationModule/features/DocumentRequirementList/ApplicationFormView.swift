//
//  ApplicationFormView.swift
//  Visaku
//
//  Created by Nur Nisrina on 11/11/24.
//

import SwiftUI
import UIComponentModule

struct ApplicationFormView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Image("applicationForm")
                    VStack {
                        Text("Informasi bepergian")
                            .font(.system(size: 20))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .bold()
                            .opacity(0.8)
                        VStack {
                            
                            CardContainer(cornerRadius: 18) {
                                ScrollView {
                                    Text("Negara yang menjadi titik masuk pertama Anda ke wilayah Schengen")
                                        .foregroundStyle(.secondary)
                                    ForEach(Countries.schengenCountryList, id: \.self) { schengenCountry in
                                        VStack {
                                            Divider()
                                            VStack {
                                                Text(schengenCountry)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    .opacity(0.8)
                                            }
                                            .padding(.horizontal)
                                        }
                                        
                                    }
                                }
                            }
                        }
                        
                    }
                    .padding()
                }
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Form aplikasi")
                    .font(.system(size: 24))
                    .bold()
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 16))
                        .padding(10)
                        .bold()
                        .background(Circle().fill(Color.white))
                        .foregroundColor(.black)
                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                }
            }
        }
    }
        
}

#Preview {
    ApplicationFormView()
}
