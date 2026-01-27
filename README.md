# Hebrew Interlinear Old Testament (Flutter)

A modern, cross-platform (Mobile & Web) reimplementation of the [legacy Android Hebrew Interlinear Bible](https://github.com/peace-shillong/Hebrew-Interlinear-Old-Testament-Android). This app provides a word-for-word Hebrew-English interlinear study tool with Strong's concordance integration.

## 📱 Features

* **Interlinear Display:** Vertical stacking of Hebrew, Transliteration, English Gloss, Lemma, and Strong's Numbers.
* **Cross-Platform:**
    * **Mobile:** Swipeable verse-by-verse navigation.
    * **Web/Desktop:** Responsive split-screen layout with a persistent selection sidebar.
* **Strong's Lookup:** Tap any Strong's number to view the full definition in a popup.
* **Customization:** Adjustable Hebrew font size using Material 3 sliders.
* **Persistence:** Remembers your last read Book, Chapter, and Verse automatically.
* **RTL Support:** Native Right-to-Left text rendering for accurate Hebrew display.

## 🛠 Tech Stack

* **Framework:** Flutter (Material 3)
* **Language:** Dart
* **Database:** [Drift](https://drift.simonbinder.eu/) (SQLite abstraction)
* **State Management:** [Provider](https://pub.dev/packages/provider)
* **Settings:** [Shared Preferences](https://pub.dev/packages/shared_preferences)
* **Typography:** [Google Fonts](https://pub.dev/packages/google_fonts) (Noto Serif Hebrew)

## 📂 Project Structure

The project follows a Clean Architecture approach separating Data, Logic, and UI.

```text
lib/
├── core/
│   ├── constants/          # App-wide constants
│   └── theme/              # Material 3 Theme config
├── data/
│   ├── database.dart       # Drift database & schema definitions
│   └── ot.sqlite           # (Asset) Pre-populated database
├── providers/
│   ├── bible_provider.dart # Manages selection state (Book/Chapter/Verse)
│   └── settings_provider.dart # Manages font size & persistence
├── ui/
│   ├── responsive_layout.dart # Switcher for Mobile vs. Web view
│   ├── screens/            # Full screen pages (MobileSelection, WebMain, etc.)
│   └── widgets/            # Reusable UI (InterlinearWord, VerseDisplay, etc.)
└── main.dart
```

🚀 Getting Started
1. Prerequisites
Flutter SDK (Latest Stable)

Dart SDK

2. Database Setup (Crucial Step)
The app relies on a pre-populated SQLite database (ot.sqlite).

Create a folder named assets/database/ in the project root.

Place your ot.sqlite file (approx 28MB) inside assets/database/.

Ensure your pubspec.yaml contains:

YAML
flutter:
  assets:
    - assets/database/ot.sqlite
3. Installation
Clone the repository and install dependencies:

Bash
git clone [https://github.com/your-username/hebrew-interlinear-flutter.git](https://github.com/your-username/hebrew-interlinear-flutter.git)
cd hebrew-interlinear-flutter
flutter pub get
4. Code Generation
This project uses Drift, which requires code generation for the database implementation. Run the following command to generate database.g.dart:

Bash
dart run build_runner build
(If you encounter errors, try dart run build_runner build --delete-conflicting-outputs)

5. Running the App
For Mobile (Android/iOS):

Bash
flutter run
For Web:

Bash
flutter run -d chrome
🏗 Architecture Details
Database Layer
The app uses a Lazy Database strategy. On the very first run, it copies the ot.sqlite file from the app bundle (assets) to the device's local application documents directory. This ensures the database is writable and persistent.

Responsive Logic
The app checks the screen width at runtime:

Width < 800px: Loads MobileSelectionScreen (Navigation stack based).

Width > 800px: Loads WebMainScreen (Master-Detail persistent layout).

📄 License
[Add your license here, e.g., MIT, Apache 2.0]

🙏 Acknowledgements
Based on the original Android work by Peace Shillong.