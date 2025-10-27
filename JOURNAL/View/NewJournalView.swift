//
//  NewJournalView.swift
//  JOURNAL
//
//  Created by رغد الجريوي on 22/10/2025.
//

import SwiftUI

struct NewJournalView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var vm: JournalViewModel

    @State private var title: String = ""
    @State private var content: String = ""
    @FocusState private var isTitleFocused: Bool
    @State private var showDiscardAlert = false

    private var dateString: String {
        Date().formatted(date: .abbreviated, time: .shortened)
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Button {
                        if !title.isEmpty || !content.isEmpty {
                            showDiscardAlert = true
                        } else {
                            dismiss()
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.white)
                    }

                    Spacer()

                    Button {
                        vm.addEntry(title: title, content: content)
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 20)

                TextField("Title", text: $title)
                    .font(.custom("SFPro-Bold", size: 28))
                    .foregroundColor(.white)
                    .textInputAutocapitalization(.sentences)
                    .disableAutocorrection(true)
                    .padding(.horizontal)
                    .focused($isTitleFocused)

                Text(dateString)
                    .font(.custom("SFPro-Semibold", size: 13))
                    .foregroundColor(.gray)
                    .padding(.horizontal)

                ZStack(alignment: .topLeading) {
                    if content.isEmpty {
                        Text("Type your Journal...")
                            .font(.custom("SFPro-Regular", size: 16))
                            .foregroundColor(.white.opacity(0.6))
                            .padding(.top, 8)
                            .padding(.horizontal, 6)
                            .allowsHitTesting(false)
                    }
                    TextEditor(text: $content)
                        .font(.custom("SFPro-Regular", size: 16))
                        .foregroundColor(.white)
                        .scrollContentBackground(.hidden)
                        .padding(4)
                }
                .padding(.horizontal)

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 20/255, green: 20/255, blue: 32/255),
                        Color.black
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .ignoresSafeArea()
            .alert("Discard new journal?", isPresented: $showDiscardAlert) {
                Button("Discard Changes", role: .destructive) { dismiss() }
                Button("Keep Editing", role: .cancel) { }
            }
            .onAppear { isTitleFocused = true }
        }
    }
}
