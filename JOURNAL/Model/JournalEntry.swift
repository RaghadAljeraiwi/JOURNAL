//
//  JournalEntry.swift
//  JOURNAL
//
//  Created by رغد الجريوي on 26/10/2025.
//
import Foundation

struct JournalEntry: Identifiable {
    let id = UUID()
    var title: String
    let date: String
    var content: String
    var isBookmarked: Bool
}
