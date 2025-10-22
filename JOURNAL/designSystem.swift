//
//  designSystem.swift
//  JOURNAL
//
//  Created by رغد الجريوي on 22/10/2025.
//

import SwiftUI

enum AppColors {
    static let backgroundTop = Color(red: 20/255, green: 20/255, blue: 32/255)
    static let backgroundBottom = Color.black
    static let title = Color.white
    static let subtitle = Color.white
    static let accentText = Color(red: 184/255, green: 172/255, blue: 255/255)
    static let iconOnDark = Color.white
    static let searchText = Color.gray
    static let searchBg = Color.white.opacity(0.08)
}

enum AppSpacing {
    static let xs: CGFloat = 6
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 40
}

enum AppFont {
    static func title() -> Font { .system(size: 34, weight: .bold) }
    static func h2() -> Font { .system(size: 22, weight: .bold) }
    static func bodyLight(_ size: CGFloat = 18) -> Font { .system(size: size, weight: .light) }
    static func search() -> Font { .system(size: 16, weight: .light) }
}
