📔 Journali

A refined digital journal app that turns daily thoughts into meaningful reflections.

⸻

🧭 Overview

Journali is an iOS application designed to provide users with an elegant and intuitive space to document their personal reflections.
The app was developed during the Apple Developer Academy “Hello World!” challenge, where the focus was on translating a pre-defined design prototype into a fully functional SwiftUI interface while maintaining high standards of UI consistency, usability, and clean code architecture.

Journali serves as a minimal yet powerful journaling experience — allowing users to record, organize, and revisit their memories with seamless interaction. It integrates speech recognition, search capabilities, and dynamic content management, all within a polished user interface inspired by Apple’s Human Interface Guidelines.

🎯 Objectives
	•	Transform a detailed Sketch prototype into a functional iOS application.
	•	Implement an efficient data model and apply the MVVM architectural pattern.
	•	Emphasize code readability, scalability, and reusable UI components.
	•	Enhance user interaction through voice recognition, swipe gestures, and search filtering

  🧩 Key Features
	•	Journal Creation & Editing: Add, edit, and store journal entries effortlessly.
	•	Voice Search Integration: Search entries through speech recognition using Apple’s Speech framework.
	•	Smart Filtering: Sort journals by date or bookmarked entries for quick navigation.
	•	Swipe Actions: Delete entries using gesture-based interactions with visual feedback.
	•	Adaptive UI: Smooth layout built with VStack, ZStack, and ScrollView, responsive across iPhone devices.
	•	Persistent Empty State: A guided entry screen appears when no journals exist, enhancing user onboarding.

  🧱 Technical Implementation

Journali follows the Model–View–ViewModel (MVVM) architecture, ensuring clear separation between data logic and UI presentation.
The application leverages SwiftUI’s declarative syntax for clean, reactive views, and integrates AVFoundation and Speech frameworks for voice functionality.

Core Technologies:
	•	Swift • SwiftUI • AVFoundation • Speech
	•	Xcode 15 • iOS 17 SDK
	•	Sketch (UI Prototyping)

Design Principles:
	•	Accessibility and minimal interaction cost
	•	Consistent color hierarchy and typography system
	•	Alignment with Apple’s HIG

  🧠 Learning Outcomes

Through this project, the following development concepts were applied and demonstrated:
	•	Mastery of state management (@State, @Binding, @ObservedObject, @StateObject).
	•	Structuring SwiftUI components following MVVM principles.
	•	Creating interactive list views with animations and gesture detection.
	•	Managing modals, alerts, and navigation layers dynamically.
	•	Handling user input, validation, and error states in real time.


  Journali/
│
├── JournaliApp.swift          → Application entry point  
├── MainView.swift             → Root view containing layout and state handling  
├── JournalViewModel.swift     → Core business logic (MVVM)  
├── SpeechRecognizer.swift     → Speech-to-text and voice input handling  
├── Components/                → Reusable UI elements  
└── Assets.xcassets            → Application icons and visual assets  


🖌️ Design & User Experience

The user interface was prototyped using Sketch, emphasizing emotional design and user focus.
The dark theme enhances visual comfort and draws attention to content hierarchy, while the accent color reflects a calm, reflective mood suitable for journaling.

A user flow was mapped to define:
	1.	Adding new journal entries
	2.	Editing and updating content
	3.	Filtering by bookmark or date
	4.	Deleting entries with confirmation alert

  🚀 Installation & Run

Requirements:
	•	macOS 14.0 or later
	•	Xcode 15+
	•	iOS 17 SDK


👩🏻‍💻 Author

Raghad Aljeraiwi
Physicist & iOS Developer in Training | Apple Developer Academy Learner

“Combining scientific precision with creative design — crafting meaningful digital experiences through code.”
