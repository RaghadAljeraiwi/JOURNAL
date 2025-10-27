//
//  JournalViewModel.swift
//  JOURNAL
//
//  Created by رغد الجريوي on 26/10/2025.
//

import SwiftUI
import Combine
import Foundation

@MainActor
final class JournalViewModel: ObservableObject {
    @Published var entries: [JournalEntry] = []

    func addEntry(title: String, content: String) {
        let dateString = Date().formatted(date: .abbreviated, time: .shortened)
        let entry = JournalEntry(
            title: title.isEmpty ? "Untitled" : title,
            date: dateString,
            content: content,
            isBookmarked: false
        )
        entries.append(entry)
    }

    func deleteEntry(id: UUID) {
        if let idx = entries.firstIndex(where: { $0.id == id }) {
            entries.remove(at: idx)
        }
    }

    func toggleBookmark(id: UUID) {
        if let idx = entries.firstIndex(where: { $0.id == id }) {
            entries[idx].isBookmarked.toggle()
        }
    }
}
