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

    @State private var isExpanded: Bool
    @State private var isDisplaySheet: Bool = false
    @State private var searchKeyword: String = ""
    
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
                ExpandableHeader(title: title, isExpanded: $isExpanded) {
                    isDisplaySheet = isExpanded && options.count >= 6
                }
                
                if isExpanded && options.count < 6 {
                    OptionsListView(options: options, mode: mode, singleSelection: $singleSelection, multipleSelection: $multipleSelection, isExpanded: $isExpanded)
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
                searchKeyword: $searchKeyword,
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
    
    private var selectedOptionsText: String {
        mode == .single ? (singleSelection ?? "") : multipleSelection.joined(separator: ", ")
    }
    
    private func handleSelection(_ selected: String) {
        if mode == .single {
            singleSelection = selected
        } else if let index = multipleSelection.firstIndex(of: selected) {
            multipleSelection.remove(at: index)
        } else {
            multipleSelection.append(selected)
        }
    }
}

struct CustomRadioButton: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        SelectionButton(label: label, icon: isSelected ? "record.circle.fill" : "circle", action: action)
    }
}

struct CustomCheckbox: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        SelectionButton(label: label, icon: isSelected ? "checkmark.square.fill" : "square", action: action)
    }
}

public struct CustomFormField: View {
    let title: String
    @Binding var text: String
    @State private var isExpanded: Bool = true
    var keyboardType: UIKeyboardType = .default

    public var body: some View {
        CardContainer(cornerRadius: 12) {
            VStack(spacing: 12) {
                ExpandableHeader(title: title, isExpanded: $isExpanded)
                
                if isExpanded {
                    TextFieldView(text: $text, title: title, keyboardType: keyboardType) {
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

public struct CustomDateField: View {
    let title: String
    @Binding var date: Date?
    @State private var isExpanded: Bool = false
    
    public var body: some View {
        CardContainer(cornerRadius: 12) {
            VStack(spacing: 12) {
                ExpandableHeader(title: title, isExpanded: $isExpanded)
                
                if isExpanded {
                    DatePickerView(date: $date) {
                        isExpanded = false
                    }
                } else {
                    Text(dateDisplayText)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
    
    private var dateDisplayText: String {
        date.map { DateFormatter.localizedString(from: $0, dateStyle: .medium, timeStyle: .none) } ?? "Select Date"
    }
}

struct ExpandableHeader: View {
    let title: String
    @Binding var isExpanded: Bool
    var onTap: (() -> Void)? = nil
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundStyle(.secondary)
            Spacer()
            Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .onTapGesture {
            isExpanded.toggle()
            onTap?()
        }
    }
}

struct OptionsListView: View {
    let options: [String]
    let mode: SelectionMode
    @Binding var singleSelection: String?
    @Binding var multipleSelection: [String]
    @Binding var isExpanded: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(options, id: \.self) { option in
                Divider()
                if mode == .single {
                    CustomRadioButton(label: option, isSelected: singleSelection == option) {
                        singleSelection = option
                        isExpanded = false
                    }
                } else {
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
    }
}

struct DatePickerView: View {
    @Binding var date: Date?
    var onDateSelected: () -> Void

    var body: some View {
        DatePicker(
            "",
            selection: Binding(
                get: { date ?? Date() },
                set: { newDate in
                    date = newDate
                    onDateSelected()
                }
            ),
            displayedComponents: .date
        )
        .datePickerStyle(.graphical)
        .labelsHidden()
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

struct SelectionButton: View {
    let label: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(icon == "circle" || icon == "square" ? .gray : .blue)
                Text(label)
                    .foregroundColor(.black)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct TextFieldView: View {
    @Binding var text: String
    let title: String
    let keyboardType: UIKeyboardType
    let onCommit: () -> Void
    
    var body: some View {
        TextField(title, text: $text)
            .keyboardType(keyboardType)
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            .foregroundColor(.black)
            .font(.body)
            .onSubmit(onCommit)
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
