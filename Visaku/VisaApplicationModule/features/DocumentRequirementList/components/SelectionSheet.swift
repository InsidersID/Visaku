//
//  SelectionSheet.swift
//  Visaku
//
//  Created by Nur Nisrina on 12/11/24.
//

import SwiftUI

struct SelectionSheet<Item: Hashable>: View {
    @Binding var isPresented: Bool
    @Binding var searchKeyword: String
    var items: [Item]
    var itemText: (Item) -> String
    var onItemSelected: (Item) -> Void
    var onDismiss: () -> Void

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(items.filter { searchKeyword.isEmpty || itemText($0).contains(searchKeyword) }, id: \.self) { item in
                        Button(action: {
                            onItemSelected(item)
                            isPresented = false
                        }) {
                            Text(itemText(item))
                                .font(.title3)
                                .foregroundStyle(.black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .bold()
                        }
                    }
                }
                .searchable(text: $searchKeyword, prompt: "Search")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Pilih Item")
                            .font(.headline)
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            onDismiss()
                            isPresented = false
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 16))
                                .bold()
                                .padding(10)
                                .background(Circle().fill(Color.white))
                                .foregroundColor(.black)
                                .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                        }
                    }
                }
                .presentationDetents([.medium])
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    @Previewable @State var isSheetPresented = true
    @Previewable @State var searchKeyword = ""
    @Previewable @State var selectedItem = ""

    let countries = ["USA", "Canada", "Mexico", "Schengen Area", "Australia", "Japan"]

    SelectionSheet(
        isPresented: $isSheetPresented,
        searchKeyword: $searchKeyword,
        items: countries,
        itemText: { $0 },
        onItemSelected: { selected in
            selectedItem = selected
        },
        onDismiss: {
        }
    )
}
