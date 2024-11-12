//
//  ExpandableSelection.swift
//  Visaku
//
//  Created by Nur Nisrina on 12/11/24.
//

import SwiftUI
import UIComponentModule

public enum SelectionMode {
    case single
    case multiple
}

public struct ExpandableSelection: View {
    let title: String
    let options: [String]
    let mode: SelectionMode

    @Binding var singleSelection: String?
    @Binding var multipleSelection: [String]

    @State private var isExpanded: Bool = false
    @State private var isDisplaySheet: Bool = false
    
    public init(title: String, options: [String], mode: SelectionMode, singleSelection: Binding<String?>, multipleSelection: Binding<[String]>) {
        self.title = title
        self.options = options
        self.mode = mode
        self._singleSelection = singleSelection
        self._multipleSelection = multipleSelection
        self._isExpanded = State(initialValue: options.count < 6)
    }
    
    public var body: some View {
        CardContainer(cornerRadius: 12) {
            VStack(spacing: 12) {
                HStack {
                    Text(title)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .onTapGesture {
                    isExpanded.toggle()
                    isDisplaySheet = isExpanded && options.count >= 6
                }
                
                if isExpanded && options.count < 6 {
                    VStack(alignment: .leading) {
                        ForEach(options, id: \.self) { option in
                            Divider()
                            if mode == .single {
                                CustomRadioButton(label: option, isSelected: singleSelection == option) {
                                    singleSelection = option
                                    isExpanded = false
                                }
                            } else if mode == .multiple {
                                CustomCheckbox(label: option, isSelected: multipleSelection.contains(option)) {
                                    if multipleSelection.contains(option) {
                                        multipleSelection.removeAll { $0 == option }
                                    } else {
                                        multipleSelection.append(option)
                                    }
                                }
                            }
                        }
                    }
                } else if !selectedOptionsText.isEmpty {
                    Text(selectedOptionsText)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .sheet(isPresented: $isDisplaySheet) {
            SelectionSheet(
                isPresented: $isDisplaySheet,
                searchKeyword: .constant(""),
                items: options,
                itemText: { $0 },
                onItemSelected: { selected in
                    if mode == .single {
                        singleSelection = selected
                    } else {
                        if multipleSelection.contains(selected) {
                            multipleSelection.removeAll { $0 == selected }
                        } else {
                            multipleSelection.append(selected)
                        }
                    }
                },
                onDismiss: { isExpanded = false }
            )
        }
    }
    
    public var selectedOptionsText: String {
        if mode == .single {
            return singleSelection ?? ""
        } else {
            return multipleSelection.joined(separator: ", ")
        }
    }
}

struct CustomRadioButton: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: isSelected ? "record.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .blue : .gray)
                Text(label)
                    .foregroundColor(.black)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CustomCheckbox: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                    .foregroundColor(isSelected ? .blue : .gray)
                Text(label)
                    .foregroundColor(.black)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

public struct CustomFormField: View {
    let title: String
    @Binding var text: String
    @State var isExpanded: Bool = true
    var keyboardType: UIKeyboardType = .default

    public var body: some View {
        CardContainer(cornerRadius: 12) {
            VStack(spacing: 12) {
                HStack {
                    Text(title)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .onTapGesture {
                    isExpanded.toggle()
                }
                if isExpanded {
                    TextField(title, text: $text)
                        .keyboardType(keyboardType)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .foregroundColor(.black)
                        .font(.body)
                        .onSubmit {
                            isExpanded = false
                        }
                } else {
                    Text(text)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
}


#Preview {
    @Previewable @State var yesNoSelection: String? = nil
    @Previewable @State var singleOptionSelection: String? = nil
    @Previewable @State var multipleSelections: [String] = []
    
    VStack {
        ExpandableSelection(
            title: "Yes or No Question",
            options: ["Yes", "No"],
            mode: .single,
            singleSelection: $yesNoSelection,
            multipleSelection: .constant([])
        )
        
        ExpandableSelection(
            title: "Single Choice Question",
            options: ["Option 1", "Option 2", "Option 3", "Option 4", "Option 5", "Option 6"],
            mode: .single,
            singleSelection: $singleOptionSelection,
            multipleSelection: .constant([])
        )
        
        ExpandableSelection(
            title: "Multiple Selection",
            options: ["Option A", "Option B", "Option C"],
            mode: .multiple,
            singleSelection: .constant(nil),
            multipleSelection: $multipleSelections
        )
    }
}
