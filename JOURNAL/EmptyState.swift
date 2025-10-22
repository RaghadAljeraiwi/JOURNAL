import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack {
            // Title bar
            HStack {
                Text("Journal")
                    .font(.custom("SFPro-Bold", size: 34))   // نوع الخط وحجمه
                    .foregroundColor(.white)                 // اللون rgba(255,255,255,1)
                    .frame(width: 120, height: 41, alignment: .leading)
                Spacer()
                HStack(spacing: 8) {
                    Image(systemName: "list.bullet")
                        .foregroundColor(.white)
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                }
                .padding(8)
                .background(Color.black.opacity(0.3))
                .clipShape(Capsule())
            }
            .padding(.horizontal)
            .padding(.top, 40)

            Spacer()
//
            // Image (book illustration)
            Image("openBook") // غيري الاسم إلى اسم الصورة عندك في الـ assets
                .resizable()
                .scaledToFit()
                .frame(width: 180, height: 180)

            // Main text
            Text("Begin Your Journal")
                .font(.custom("SFPro-Bold", size: 22))
                .kerning(0.5) // تباعد بسيط بين الحروف مثل التصميم
                .frame(height: 28)
                .foregroundColor(Color(red: 184/255, green: 172/255, blue: 255/255))
                .padding(.top, 24)

            // Subtitle
            Text("Craft your personal diary, tap the plus icon to begin.")
                .font(.custom("SFPro-Light", size: 18))
                .kerning(0.6)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .frame(width: 282, height: 53)
                .padding(.top, 6)

            Spacer()

            // Search bar placeholder
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                Text("Search")
                    .foregroundColor(.gray)
                    .font(.custom("SFPro-Light", size: 16))
                Spacer()
                Image(systemName: "mic.fill")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.white.opacity(0.08))
            .clipShape(Capsule())
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
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
    }
}

#Preview {
    EmptyStateView()
}


