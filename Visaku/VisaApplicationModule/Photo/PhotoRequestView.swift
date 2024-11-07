//
//  PhotoRequestView.swift
//  VisaApplicationModule
//
//  Created by Lonard Steven on 18/10/24.
//

import SwiftUI
import PhotosUI
import UIComponentModule

public struct PhotoRequestView: View {
    @State public var selectedPhotos: [PhotosPickerItem] = []
    @State public var identifiableImage: IdentifiableImage? = nil
    @State public var isPhotoPickerPresented: Bool = false
    
    public init() {
        
    }
    
    public var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Image(systemName: "photo.on.rectangle.angled")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                    
                    Text("Foto belum ada!")
                        .font(.title)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                    
                    Text("Dengan itinerary, kedutaan jadi tahu kamu punya tujuan jelas dan nggak berencana tinggal lebih lama dari yang diizinkan.")
                        .font(.caption)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                    
                    CustomButton(text: "Ambil foto", textColor: Color.white, color: Color.blue, font: 12, cornerRadius: 14, paddingHorizontal: 16, paddingVertical: 15) {
                        return
                    }

                    CustomButton(text: "Upload foto", textColor: Color.blue, color: Color.blue.opacity(0), font: 12, cornerRadius: 14, paddingHorizontal: 16, paddingVertical: 15) {
                        isPhotoPickerPresented.toggle()
                    }
                    .sheet(isPresented: $isPhotoPickerPresented) {
                        
                        PhotosPicker(selection: $selectedPhotos, maxSelectionCount: 1, selectionBehavior: .default, matching: .images) {
                            Text("Select your identity card photo")
                        }
                        .onChange(of: selectedPhotos) { newPhotos in
                            guard let newPhoto = newPhotos.first else { return }
                            Task {
                                if let data = try? await newPhoto.loadTransferable(type: Data.self),
                                   let uiImage = UIImage(data: data) {
                                    identifiableImage = IdentifiableImage(image: uiImage)
                                }
                            }
                        }
                    }
                    .presentationDetents([.medium])
                }
                .padding()
            }
        }
        .sheet(item: $identifiableImage) { image in
            PhotoResultView(image: Image(uiImage: image.image))
        }
    }
}

public struct IdentifiableImage: Identifiable {
    public var id = UUID()
    public var image: UIImage
}
