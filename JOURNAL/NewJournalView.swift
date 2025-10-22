//
//  NewJournalView.swift
//  JOURNAL
//
//  Created by رغد الجريوي on 22/10/2025.
//

import SwiftUI

struct NewJournalView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var journals: [MainView.JournalEntry]
    
    @State private var title = ""
    @State private var content = ""
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                TextField("Title", text: $title)
                    .font(.title2)
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                
                TextEditor(text: $content)
                    .frame(height: 250)
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .scrollContentBackground(.hidden)
                
                Spacer()
            }
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 20/255, green: 20/255, blue: 32/255),
                        Color(red: 0/255, green: 0/255, blue: 0/255)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .navigationTitle("New Journal")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.gray)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        let newEntry = MainView.JournalEntry(
                            title: title.isEmpty ? "Untitled" : title,
                            date: Date().formatted(date: .abbreviated, time: .omitted),
                            content: content,
                            isBookmarked: false
                        )
                        journals.append(newEntry)
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.purple)
                            .font(.title2)
                    }
                }
            }
        }
    }
}
