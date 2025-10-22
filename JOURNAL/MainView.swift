import SwiftUI

struct MainView: View {
    // نموذج مبدئي للمذكرات
    struct JournalEntry: Identifiable {
        let id = UUID()
        var title: String
        let date: String
        var content: String
        var isBookmarked: Bool
    }

    // بيانات تجريبية مؤقتة
    @State private var journals: [JournalEntry] = []
    @State private var showingNewJournalSheet = false
    @State private var selectedJournal: JournalEntry? = nil
    @State private var showBookmarkedOnly = false
    
    var body: some View {
        VStack {
            // Title bar
            HStack {
                Text("Journal")
                    .font(.custom("SFPro-Bold", size: 38))
                    .foregroundColor(.white)
                Spacer()
                HStack(spacing: 8) {
                    Button {
                        showBookmarkedOnly.toggle()
                    } label: {
                        Image(systemName: showBookmarkedOnly ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                            .foregroundColor(showBookmarkedOnly ? Color(red: 184/255, green: 172/255, blue: 255/255) : .white)
                    }

                    Button(action: {
                        showingNewJournalSheet = true
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                    }
                    .sheet(isPresented: $showingNewJournalSheet) {
                        NewJournalSheet(journals: $journals)
                            .presentationDetents([.large])
                            .presentationDragIndicator(.hidden)
                            .presentationBackground(.clear)
                    }
                }
                .padding(8)
                .background(Color.black.opacity(0.3))
                .clipShape(Capsule())
            }
            .padding(.horizontal)
            .padding(.top, 40)

            // Scrollable list of journals
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(journals.filter { !showBookmarkedOnly || $0.isBookmarked }) { journal in
                        // Find the correct binding for this journal
                        if let idx = journals.firstIndex(where: { $0.id == journal.id }) {
                            let binding = $journals[idx]
                            Button {
                                selectedJournal = journal
                            } label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(binding.title.wrappedValue)
                                            .font(.custom("SFPro-Bold", size: 22))
                                            .foregroundColor(.white)

                                        Text(journal.date)
                                            .font(.custom("SFPro-Semibold", size: 13))
                                            .foregroundColor(.gray)

                                        Text(binding.content.wrappedValue)
                                            .font(.custom("SFPro-Regular", size: 16))
                                            .foregroundColor(.white)
                                            .lineLimit(2)
                                            .lineSpacing(5)
                                    }
                                    Spacer()
                                    Button {
                                        binding.isBookmarked.wrappedValue.toggle()
                                    } label: {
                                        Image(systemName: binding.isBookmarked.wrappedValue ? "bookmark.fill" : "bookmark")
                                            .foregroundColor(binding.isBookmarked.wrappedValue
                                                             ? Color(red: 184/255, green: 172/255, blue: 255/255)
                                                             : .gray)
                                    }
                                    .buttonStyle(.plain)
                                }
                                .padding()
                                .background(Color.white.opacity(0.08))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .padding(.horizontal)
                            }
                        }
                    }
                }
                .padding(.top)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
        .ignoresSafeArea()
        .sheet(item: $selectedJournal) { item in
            if let idx = journals.firstIndex(where: { $0.id == item.id }) {
                EditJournalSheet(journal: $journals[idx])
                    .presentationDetents([.large])
                    .presentationDragIndicator(.hidden)
                    .presentationBackground(.clear)
            } else {
                // Fallback to avoid empty content
                Color.clear
                    .presentationDetents([.large])
                    .presentationDragIndicator(.hidden)
                    .presentationBackground(.clear)
            }
        }
    }
}
// Removed duplicate import SwiftUI

struct NewJournalSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var journals: [MainView.JournalEntry]

    @State private var title: String = ""
    @State private var content: String = ""
    @FocusState private var isTitleFocused: Bool
    @State private var showDiscardAlert = false

    private var dateString: String {
        Date().formatted(date: .abbreviated, time: .omitted)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Top bar: X (close) and checkmark (save)
            HStack {
                Button {
                    if !title.isEmpty || !content.isEmpty {
                        // Ask before closing if there’s text written
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
                    let entry = MainView.JournalEntry(
                        title: title.isEmpty ? "Untitled" : title,
                        date: dateString,
                        content: content,
                        isBookmarked: false
                    )
                    journals.append(entry)
                    dismiss()
                } label: {
                    Image(systemName: "checkmark")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal)
            .padding(.top, 20)

            // Title field
            TextField("Title", text: $title)
                .font(.custom("SFPro-Bold", size: 28))
                .foregroundColor(.white)
                .textInputAutocapitalization(.sentences)
                .disableAutocorrection(true)
                .padding(.horizontal)
                .focused($isTitleFocused)

            // Date
            Text(dateString)
                .font(.custom("SFPro-Semibold", size: 13))
                .foregroundColor(.gray)
                .padding(.horizontal)

            // Content editor with placeholder
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
                    .lineSpacing(5)
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
                    Color(red: 0/255, green: 0/255, blue: 0/255)
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

struct EditJournalSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var journal: MainView.JournalEntry
    @State private var editedTitle: String
    @State private var editedContent: String
    @FocusState private var isContentFocused: Bool
    @State private var showDiscardAlert = false
    
    init(journal: Binding<MainView.JournalEntry>) {
        _journal = journal
        _editedTitle = State(initialValue: journal.wrappedValue.title)
        _editedContent = State(initialValue: journal.wrappedValue.content)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Top bar
            HStack {
                Button {
                    if editedTitle != journal.title || editedContent != journal.content {
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
                    journal.title = editedTitle
                    journal.content = editedContent
                    dismiss()
                } label: {
                    Image(systemName: "checkmark")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal)
            .padding(.top, 20)

            // Title field
            TextField("Title", text: $editedTitle)
                .font(.custom("SFPro-Bold", size: 28))
                .foregroundColor(.white)
                .padding(.horizontal)
                .focused($isContentFocused)

            // Date
            Text(journal.date)
                .font(.custom("SFPro-Semibold", size: 13))
                .foregroundColor(.gray)
                .padding(.horizontal)

            // Content editor
            ZStack(alignment: .topLeading) {
                if editedContent.isEmpty {
                    Text("Type your Journal...")
                        .foregroundColor(.white.opacity(0.6))
                        .padding(.top, 8)
                        .padding(.horizontal, 5)
                }
                TextEditor(text: $editedContent)
                    .font(.custom("SFPro-Regular", size: 16))
                    .foregroundColor(.white)
                    .scrollContentBackground(.hidden)
                    .padding(4)
            }
            .padding(.horizontal)
            .onAppear { isContentFocused = true }

            Spacer()
        }
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
        .ignoresSafeArea()
        .alert("Are you sure you want to discard changes on this journal?",
               isPresented: $showDiscardAlert) {
            Button("Discard Changes", role: .destructive) {
                dismiss()
            }
            Button("Keep Editing", role: .cancel) {}
        }
    }
}

#Preview {
    MainView()
}
