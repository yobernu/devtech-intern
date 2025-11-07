# 📝 To-Do List App

A feature-rich Flutter application for managing your daily tasks with a clean and intuitive interface. The app allows users to create, edit, and organize their tasks with additional features like task categories, due dates, and cloud synchronization.

## ✨ Features

- 🔄 **Task Management**: Create, edit, and delete tasks
- ✅ **Task Completion**: Mark tasks as complete/incomplete
- 📅 **Calendar Integration**: View tasks in a calendar layout
- 🌐 **Cloud Sync**: Data is synced across devices using Firebase
- 🔒 **User Authentication**: Secure login/signup with Firebase Auth
- 📱 **Responsive Design**: Works on both mobile and tablet
- 📂 **Categories**: Organize tasks into different categories
- 🔍 **Search & Filter**: Easily find your tasks

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Android Studio / Xcode (for emulator/simulator)
- Firebase account (for backend services)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yobernu/devtech-intern.git
   cd todoapp
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up Firebase**
   - Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Add a new Android/iOS app and follow the setup instructions
   - Download the configuration files and place them in the appropriate directories:
     - Android: `android/app/google-services.json`
     - iOS: `ios/Runner/GoogleService-Info.plist`

4. **Run the app**
   ```bash
   flutter run
   ```

## 🛠️ Tech Stack & Libraries

- **Framework**: Flutter
- **State Management**: Provider
- **Backend**: Firebase (Firestore)
- **UI Components**: 
  - Syncfusion Flutter Calendar
  - Flutter Zoom Drawer
  - Font Awesome Icons
- **Local Storage**: Shared Preferences
- **Dependency Injection**: Provider
- **Networking**: Firebase SDKs
- **Utilities**:
  - Equatable (for value equality)
  - Dartz (functional programming)
  - Internet Connection Checker
  - Shared Preferences

## 📁 Project Structure

```
lib/
├── core/
│   ├── constants/    # App-wide constants
│   └── errors/       # Custom error classes
├── features/
│   └── toDoListApp/
│       ├── data/
│       │   ├── datasources/  # Data sources (local/remote)
│       │   ├── models/       # Data models
│       │   └── repositories/ # Repository implementations
│       ├── domain/
│       │   ├── entity/       # Business entities
│       │   ├── repositories/ # Repository interfaces
│       │   └── usecase/      # Business logic
│       └── presentation/
│           ├── screens/      # App screens
│           ├── widgets/      # Reusable widgets
│           └── helpers/      # UI helpers
└── main.dart                 # App entry point
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

