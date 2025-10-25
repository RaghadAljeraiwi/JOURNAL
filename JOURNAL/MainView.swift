import Speech
import SwiftUI
import AVFoundation
import Combine


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
    @State private var showDeleteAlert = false
    @State private var journalToDelete: JournalEntry? = nil
    @State private var searchText = ""
    @StateObject private var speechRecognizer = SpeechRecognizer()
    
    var body: some View {
        ZStack {
            // الخلفية: تدرج غامق جدًا مع لمسة بنفسجية خفيفة
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 10/255, green: 10/255, blue: 20/255),
                    Color.black
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Title bar
                HStack {
                    Text("Journal")
                        .font(.custom("SFPro-Bold", size: 38))
                        .foregroundColor(.white)
                    Spacer()
                    HStack(spacing: 8) {
                        Menu {
                            Button("Sort by Bookmark") {
                                showBookmarkedOnly.toggle()
                            }
                            Button("Sort by Newest First") {
                                let formatter = DateFormatter()
                                formatter.dateStyle = .medium
                                formatter.timeStyle = .short
                                journals.sort { lhs, rhs in
                                    if let leftDate = formatter.date(from: lhs.date),
                                       let rightDate = formatter.date(from: rhs.date) {
                                        return leftDate > rightDate
                                    }
                                    return false
                                }
                            }
                            Button("Sort by Oldest First") {
                                let formatter = DateFormatter()
                                formatter.dateStyle = .medium
                                formatter.timeStyle = .short
                                journals.sort { lhs, rhs in
                                    if let leftDate = formatter.date(from: lhs.date),
                                       let rightDate = formatter.date(from: rhs.date) {
                                        return leftDate < rightDate
                                    }
                                    return false
                                }
                            }
                        } label: {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                                .foregroundColor(.white)
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
                    if journals.isEmpty {
                        // Empty State
                        GeometryReader { proxy in
                            ZStack {
                                // خلفية صورة الكتاب
                                
                                // محتوى الـ Empty State
                                VStack(spacing: 0) {
                                    Spacer(minLength: 90)
                                    Image("purplebook") // أو أي اسم الصورة الفعلية اللي تمثل الكتاب الأمامي
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 130, height: 130)
                                    VStack(spacing: 6) {
                                        Text("Begin Your Journal")
                                            .font(.custom("SFPro-Bold", size: 22))
                                            .foregroundColor(Color(red: 184/255, green: 172/255, blue: 255/255))
                                        Text("Craft your personal diary, tap the plus icon to begin")
                                            .font(.custom("SFPro-Regular", size: 14))
                                            .foregroundColor(.white.opacity(0.7))
                                    }
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 40)
                                    .padding(.top, 16)
                                    Spacer()
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        LazyVStack(spacing: 16, pinnedViews: []) {                            ForEach(
                                journals.filter {
                                    (!showBookmarkedOnly || $0.isBookmarked) &&
                                    (searchText.isEmpty ||
                                     $0.title.localizedCaseInsensitiveContains(searchText) ||
                                     $0.content.localizedCaseInsensitiveContains(searchText))
                                }
                            ) { journal in
                                if let idx = journals.firstIndex(where: { $0.id == journal.id }) {
                                    let binding = $journals[idx]
                                    SwipeToDeleteView {
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
                                        .onTapGesture { selectedJournal = journal }
                                    } onDelete: {
                                        journalToDelete = journal
                                        showDeleteAlert = true
                                    }
                                    .gesture(DragGesture()) // يضمن استجابة السحب داخل ScrollView
                                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                        Button(role: .destructive) {
                                            journalToDelete = journal
                                            showDeleteAlert = true
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                                .font(.system(size: 18, weight: .semibold))
                                        }
                                        .tint(.red)
                                    }
                                } // end if idx
                            } // end ForEach
                        } // end VStack
                        .padding(.top)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // Search bar في الأسفل (مرة واحدة)
                
                // ✅ Search bar always visible at the bottom
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray.opacity(0.8))
                    TextField("Search", text: $searchText)
                        .foregroundColor(.white)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                    Button(action: {
                        if speechRecognizer.isRecording {
                            speechRecognizer.stopRecording()
                        } else {
                            speechRecognizer.startRecording()
                        }
                    }) {
                        Image(systemName: speechRecognizer.isRecording ? "mic.slash.fill" : "mic.fill")
                            .foregroundColor(Color(red: 184/255, green: 172/255, blue: 255/255))
                    }
                }
                .padding(.horizontal, 18)
                .frame(height: 45)
                .background(
                    RoundedRectangle(cornerRadius: 22)
                        .fill(Color(red: 28/255, green: 28/255, blue: 36/255).opacity(0.9))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(Color.white.opacity(0.05), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.4), radius: 5, x: 0, y: 3)
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
                .onChange(of: speechRecognizer.transcribedText) { _, newValue in
                    searchText = newValue
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(item: $selectedJournal) { item in
            if let idx = journals.firstIndex(where: { $0.id == item.id }) {
                EditJournalSheet(journal: $journals[idx])
                    .presentationDetents([.large])
                    .presentationDragIndicator(.hidden)
                    .presentationBackground(.clear)
            } else {
                Color.clear
                    .presentationDetents([.large])
                    .presentationDragIndicator(.hidden)
                    .presentationBackground(.clear)
            }
        }
        .alert("Delete Journal?", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                if let journalToDelete = journalToDelete,
                   let index = journals.firstIndex(where: { $0.id == journalToDelete.id }) {
                    journals.remove(at: index)
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this journal?")
        }
    }
    
    class SpeechRecognizer: ObservableObject {
        private var audioEngine = AVAudioEngine()
        private var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
        private var request = SFSpeechAudioBufferRecognitionRequest()
        private var recognitionTask: SFSpeechRecognitionTask?
        
        @Published var transcribedText: String = ""
        
        func startRecording() {
            SFSpeechRecognizer.requestAuthorization { authStatus in
                guard authStatus == .authorized else {
                    print("Speech recognition not authorized")
                    return
                }
                DispatchQueue.main.async {
                    self.recordAndRecognizeSpeech()
                }
            }
        }
        
        func stopRecording() {
            audioEngine.stop()
            request.endAudio()
            recognitionTask?.cancel()
        }
        
        private func recordAndRecognizeSpeech() {
            // إعداد جلسة الصوت قبل التشغيل
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
                try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            } catch {
                print("Audio session setup failed: \(error.localizedDescription)")
                return
            }
            
            let node = audioEngine.inputNode
            let recordingFormat = node.outputFormat(forBus: 0)
            
            // 🔹 إزالة أي tap سابق لتجنب الخطأ "nullptr == Tap()"
            node.removeTap(onBus: 0)
            
            // 🔹 إضافة tap جديد
            node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
                self.request.append(buffer)
            }
            
            audioEngine.prepare()
            do {
                try audioEngine.start()
            } catch {
                print("Audio engine failed to start: \(error.localizedDescription)")
                return
            }
            
            recognitionTask = speechRecognizer?.recognitionTask(with: request) { result, error in
                if let result = result {
                    DispatchQueue.main.async {
                        self.transcribedText = result.bestTranscription.formattedString
                    }
                } else if let error = error {
                    print("Recognition error: \(error.localizedDescription)")
                }
            }
        }
        var isRecording: Bool {
            audioEngine.isRunning
        }
        var audioEngineInstance: AVAudioEngine {
            audioEngine
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
            Date().formatted(date: .abbreviated, time: .shortened)
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
    
}
struct SwipeToDeleteView<Content: View>: View {
    @State private var offsetX: CGFloat = 0
    var content: () -> Content
    var onDelete: () -> Void

    var body: some View {
        ZStack(alignment: .trailing) {
            // خلفية زر الحذف (تظهر فقط لما المستخدم يسحب)
            if offsetX < -10 {
                HStack {
                    Spacer()
                    Button(action: onDelete) {
                        Image(systemName: "trash")
                            .foregroundColor(.white)
                            .font(.system(size: 20, weight: .semibold))
                            .padding()
                            .background(Color.red)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(radius: 4)
                    }
                    .padding(.trailing, 16)
                    .transition(.move(edge: .trailing).combined(with: .opacity))
                }
            }

            // محتوى العنصر نفسه
            content()
                .offset(x: offsetX)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            if gesture.translation.width < 0 {
                                offsetX = gesture.translation.width
                            }
                        }
                        .onEnded { _ in
                            withAnimation(.spring()) {
                                // لو سحب المستخدم أكثر من 80 نقطة، ثبت الزر مؤقتًا
                                if offsetX < -80 {
                                    offsetX = -80
                                } else {
                                    offsetX = 0
                                }
                            }
                        }
                )
        }
        .animation(.spring(), value: offsetX)
    }
}
    #Preview {
        MainView()
    }

