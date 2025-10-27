//
//  JOURNALApp.swift
//  JOURNAL
//
//  Created by رغد الجريوي on 19/10/2025.
//

import SwiftUI

@main
struct JOURNALApp: App {
    @StateObject private var vm = JournalViewModel()

    var body: some Scene {
        WindowGroup {
            SplashView()
                .environmentObject(vm)
        }
    }
}
