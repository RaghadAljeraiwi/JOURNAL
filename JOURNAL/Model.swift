//
//  Model.swift
//  JOURNAL
//
//  Created by رغد الجريوي on 20/10/2025.
//

//import Foundation

//struct Journal: Identifiable {
  // let id: UUID = UUID()
    //var journalTitle: String
  //  var journalContent: String
//}
import Foundation

struct JournalEntry: Identifiable, Equatable {
    let id: UUID
    var title: String
    var body: String
    var date: Date
    var isBookmarked: Bool

    init(id: UUID = UUID(), title: String, body: String,
         date: Date = .now, isBookmarked: Bool = false) {
        self.id = id
        self.title = title
        self.body = body
        self.date = date
        self.isBookmarked = isBookmarked
    }
}
