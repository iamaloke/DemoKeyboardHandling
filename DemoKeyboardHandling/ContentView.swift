//
//  SampleFormView.swift
//  DemoKeyboardHandling
//
//  Created by Alok Kumar on 20/04/25.
//

import Combine
import SwiftUI

struct SampleFormView: View {
    
    @FocusState private var focusedTextField: FocusField?
    @State private var textfieldStates: [String] = Array(repeating: "", count: 10)
    
    var hasReachedBegin: Bool {
        guard case let .field(currentIndex) = focusedTextField else { return false }
        return currentIndex == 0
    }
    
    var hasReachedEnd: Bool {
        guard case let .field(currentIndex) = focusedTextField else { return false }
        return currentIndex == textfieldStates.count - 1
    }
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(spacing: 25) {
                        ForEach(textfieldStates.indices, id: \.self) { index in
                            TextFieldWrapperView(focusedTextField: $focusedTextField, textField: $textfieldStates[index], index: index, fieldCounter: textfieldStates.count - 1) {
                                handleSubmit(from: index)
                            }
                        }
                    }
                    .padding()
                }
                .listStyle(.plain)
                
                Spacer()
            }
            .background(.gray.opacity(0.1))
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Button(action: done) {
                        Text("Done")
                    }
                    
                    Spacer()
                    
                    Button(action: previous) {
                        Image(systemName: "chevron.up")
                    }
                    .disabled(hasReachedBegin)
                    
                    Button(action: next) {
                        Image(systemName: "chevron.down")
                    }
                    .disabled(hasReachedEnd)
                }
            }
        }
    }
    
    private func handleSubmit(from index: Int) {}
}

enum FocusField: Hashable {
    case field(index: Int)
    
    var keyboardType: UIKeyboardType {
        if case .field(let index) = self {
            if index == 2 {
                return .numberPad
            } else if index == 3 {
                return .decimalPad
            } else if index == 5 {
                return .emailAddress
            } else if index == 7 {
                return .namePhonePad
            } else if index == 11 {
                return .numbersAndPunctuation
            } else if index == 13 {
                return .webSearch
            }
        }
        return .default
    }
}

#Preview {
    NavigationView {
        SampleFormView()
    }
}

struct TextFieldWrapperView: View {
    
    @FocusState.Binding var focusedTextField: FocusField?
    @Binding var textField: String
    
    let index: Int
    let fieldCounter: Int
    let onSubmit: () -> Void
    
    var body: some View {
        HStack(spacing: 20) {
            Text("Text \(index + 1)")
                .font(.system(size: 16, weight: .medium))
                .frame(width: 60)
            
            TextField("Enter Text \(index + 1)", text: $textField)
                .textFieldStyle(.plain)
                .padding()
                .frame(height: 40)
                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                .keyboardType(focusedTextField?.keyboardType ?? .default)
                .focused($focusedTextField, equals: .field(index: index))
        }
        .padding(10)
        .background(.white)
        .clipShape(.rect(cornerRadius: 8))
    }
}

private extension SampleFormView {
    func next() {
        guard case let .field(currentIndex) = focusedTextField else { return }
        let lastIndex = textfieldStates.count - 1
        let nextIndex = min(currentIndex + 1, lastIndex)
        focusedTextField = .field(index: nextIndex)
    }
    
    func previous() {
        guard case let .field(currentIndex) = focusedTextField else { return }
        let lastIndex = textfieldStates.count - 1
        let previousIndex = min(currentIndex - 1, lastIndex)
        focusedTextField = .field(index: previousIndex)
    }
    
    func done() {
        focusedTextField = nil
    }
}
