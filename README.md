# chat_app

This is a simple two-screen chat app built with Flutter.

## Getting Started

To run this app on your local machine, follow these steps:

### Prerequisites:
    - Flutter SDK: Make sure you have Flutter installed on your machine.
    - Development Environment: Set up your development environment with an IDE such as Android Studio, Visual Studio Code, or any other editor with Flutter support.

### Instructions:
    - Clone the Repository
    - Navigate to Project Directory
    - Install Dependencies: Run the following command to install the project dependencies => flutter pub get
    - Start Emulator or Connect Device
    - Run the App: Run the following command to build and run the app on the connected device or emulator => flutter run

### Additional Information
    - The app consists of two screens: Home Screen and Chat Screen.
    - Each screen represents a different user.
    - You can navigate between screens using the bottom navigation bar.
    - To start a new conversation, tap the floating action button (FAB).

## Note
For optimal performance, it's best to use a hybrid approach, leveraging both Stream and Get operations. By doing so, we can reduce the number of reads from Firebase, synchronizing real-time updates efficiently while fetching data only as needed. This balanced approach ensures a responsive user experience without overloading the Firestore database.