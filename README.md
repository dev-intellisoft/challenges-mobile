# Taski - Todo App

A Flutter-based Todo application that allows users to manage their tasks efficiently. The app follows MVVM architecture and implements offline-first functionality using SQLite.

## Features

- List tasks with infinite scroll
- View completed tasks
- Create new tasks
- Offline-first functionality using SQLite
- Clean MVVM Architecture
- Modern UI based on Figma design

## Getting Started

### Prerequisites

- Flutter SDK (3.5.1 or higher)
- Dart SDK (3.0.0 or higher)
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/taski.git
```

2. Navigate to the project directory:
```bash
cd taski
```

3. Install dependencies:
```bash
flutter pub get
```

4. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── core/
│   ├── constants/
│   ├── errors/
│   └── utils/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── presentation/
│   ├── pages/
│   ├── viewmodels/
│   └── widgets/
└── main.dart
```

## Architecture

The project follows the MVVM (Model-View-ViewModel) architecture pattern:

- **Model**: Data layer containing entities and repositories
- **View**: UI layer containing pages and widgets
- **ViewModel**: Business logic layer containing view models

## Testing

To run tests:
```bash
flutter test
```

## Dependencies

- sqflite: ^2.3.0 - For local database
- path_provider: ^2.1.1 - For file system access
- provider: ^6.1.1 - For state management
- uuid: ^4.0.0 - For unique identifiers
- intl: ^0.19.0 - For date formatting
