# Flutter E-Commerce App

A comprehensive Flutter-based e-commerce application with shopping cart, to-do list, and multi-platform support.

## 📱 Features

- **Product Browsing**: Browse products with categories
- **Shopping Cart**: Add, remove, and manage items in cart
- **To-Do List**: Task management functionality
- **Multi-Platform**: Supports Android, iOS, Web, Windows, macOS, and Linux
- **User Authentication**: Secure user login and registration
- **Order Management**: Track and manage orders
- **Payment Integration**: Secure payment processing
- **Push Notifications**: Real-time order updates

## 🏗️ Project Structure

```
lib/
├── demo/          # Demo features and examples
├── shoppingcart/  # Shopping cart functionality
├── todolist/     # To-do list management
└── main.dart     # Application entry point
```

## 📦 Dependencies

The app uses several Flutter packages including:
- **sqflite**: Local database for offline storage
- **path_provider**: File system access
- **permission_handler**: Permission management
- **flutter_file_dialog**: File dialog utilities
- And other standard Flutter packages

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Android Studio / Xcode (for mobile development)
- VS Code (recommended)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd fhgfgfggh
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   # For Android
   flutter run

   # For iOS
   flutter run -d ios

   # For Web
   flutter run -d chrome

   # For Desktop
   flutter run -d windows
   ```

## 🔧 Build Instructions

### Android
```bash
flutter build apk --release
# or
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

### Desktop
```bash
# Windows
flutter build windows --release

# macOS
flutter build macos --release

# Linux
flutter build linux --release
```

## 📁 Directory Overview

- **`android/`**: Android-specific files and configurations
- **`ios/`**: iOS-specific files and configurations
- **`lib/`**: Main Dart application code
- **`assets/`**: Images, fonts, and other static resources
- **`test/`**: Unit and widget tests
- **`web/`**: Web-specific configurations
- **`windows/`, `macos/`, `linux/`**: Desktop platform configurations

## 🛠️ Development

### Key Components

1. **Shopping Cart Module**
   - Add/remove products
   - Quantity management
   - Price calculation
   - Checkout process

2. **To-Do List Module**
   - Task creation and deletion
   - Priority management
   - Due dates and reminders

3. **Product Management**
   - Product listing
   - Category filtering
   - Search functionality
   - Product details view

### State Management
The app uses a combination of:
- Provider for state management
- Local database (SQLite) for persistent storage
- REST API integration for product data

## 🧪 Testing

Run tests with:
```bash
# Unit tests
flutter test

# Integration tests
flutter drive --target=test_driver/app.dart
```

## 📱 Platform Support

- **Android**: 5.0+ (API 21+)
- **iOS**: 11.0+
- **Web**: Modern browsers
- **Windows**: Windows 10+
- **macOS**: 10.11+
- **Linux**: Standard Linux distributions

## 🔐 Permissions

The app requires:
- **Android**: Internet, Storage (for caching)
- **iOS**: Photo Library (if image uploads are needed)
---

## 🎥 Demo Video

Watch the full demo: [Drive Link](https://drive.google.com/file/d/1DCimVLNGK9_zb5boAM3hdG7jIe4Tf3P8/view?usp=drive_link)
