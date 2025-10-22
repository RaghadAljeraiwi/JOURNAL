//
//  Splash.swift
//  JOURNAL
//
//  Created by رغد الجريوي on 19/10/2025.
//

import SwiftUI

struct SplashView: View {
    // متغير لتحديد إذا انتهت شاشة البداية
    @State private var isActive = false
    
    var body: some View {
        if isActive {
            // بعد الانتهاء، ننتقل إلى الصفحة التالية
            MainView() // ينتقل لواجهة المذكرات // لاحقًا نبدلها بـ MainView أو EmptyStateView
        } else {
            VStack {
                Spacer()
                Image(.book)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 130, height: 130)
                
                Text("Journali")
                    .font(.system(size: 42, weight: .black, design: .default))
                        //.font(.custom("SFPro-Black", size: 42))
                        .foregroundColor(.white)
                        .frame(width: 174, height: 50)
                        .padding(.top, 8)
                        .tracking(-0.5)
                
                Text("Your thoughts, your story.")
                    .font(.custom("SFPro-Light", size: 18))
                    .foregroundColor(.white)
                    .tracking(1)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 20)
                    .padding(.top, 4)
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
            .onAppear {
                // بعد 2.5 ثانية ننتقل للصفحة التالية
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        isActive = true
                    
                }
            }
        }
    }
}

#Preview {
    SplashView()
}
