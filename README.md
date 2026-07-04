# FluxMarket 🛍️

[![Flutter](https://img.shields.io/badge/Flutter-3.12+-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.12+-0175C2?logo=dart)](https://dart.dev)
[![BLoC](https://img.shields.io/badge/State%20Management-BLoC-00897B)](https://bloclibrary.dev)
[![Clean Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture-4CAF50)](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

> **A professional-grade E-commerce mobile application** built with Flutter, showcasing Clean Architecture, BLoC state management, and modern software engineering best practices.

---

## 📑 Table of Contents

- [Architecture Overview](#-architecture-overview)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Features](#-features)
- [Screenshots](#-screenshots)
- [Getting Started](#-getting-started)
- [Code Quality & Conventions](#-code-quality--conventions)
- [Animations & UX](#-animations--ux)
- [Testing](#-testing)
- [Roadmap](#-roadmap)
- [Contributing](#-contributing)
- [License](#-license)

---

## 🏗 Architecture Overview

**FluxMarket** follows **Clean Architecture** principles, dividing the codebase into three main layers, each with strict dependency rules:

```
┌─────────────────────────────────────────────────┐
│                  PRESENTATION                   │
│   (BLoC / UI / Pages / Widgets)                │
│         ↕ depends on                           │
├─────────────────────────────────────────────────┤
│                    DOMAIN                       │
│   (Entities / Use Cases / Repositories)        │
│         ↕ depends on                           │
├─────────────────────────────────────────────────┤
│                     DATA                        │
│   (DataSources / Models / Repository Impl)     │
│         ↕                                      │
│   🌐 Remote (Dio)       💾 Local (Hive)       │
└─────────────────────────────────────────────────┘
```

### 🔑 Key Principles

- **Dependency Inversion**: High-level modules don't depend on low-level modules. Both depend on abstractions.
- **Separation of Concerns**: Each layer has a distinct responsibility, making the codebase highly testable and maintainable.
- **Unidirectional Data Flow**: UI → BLoC → Repository → DataSource → BLoC → UI.

---

## 🛠 Tech Stack

| Category | Choice | Why |
|----------|--------|-----|
| **Framework** | Flutter 3.12+ | Cross-platform, native performance |
| **Language** | Dart 3.12+ | Sound null safety, pattern matching |
| **State Management** | flutter_bloc 9.x | Predictable, testable, event-driven |
| **Dependency Injection** | get_it + injectable | Compile-time safe, auto-generated |
| **Networking** | Dio 5.x | Interceptors, retry, timeout handling |
| **Local Storage** | Hive 2.x | Fast, lightweight, NoSQL |
| **Routing** | Navigator 2.0 (MaterialPageRoute) | Simple, declarative |
| **Animation** | Lottie + Flutter Animations | Rich, performant animations |
| **Error Handling** | dartz (Either) | Functional, type-safe error handling |
| **UI Components** | google_fonts, shimmer | Beautiful, modern UI |

---

## 📂 Project Structure

```
lib/
├── core/                           # Shared core layer
│   ├── error/                      # Failure & exception definitions
│   │   ├── failures.dart           # Server, Cache, Network, Unknown failures
│   │   └── exceptions.dart         # Custom exception classes
│   ├── network/
│   │   └── network_info.dart       # Connectivity checker
│   ├── theme/
│   │   └── app_theme.dart          # Light & dark themes, spacing constants
│   ├── utils/
│   │   └── constants.dart          # App-wide constants
│   └── widgets/                    # Reusable global widgets
│       ├── app_error_widget.dart   # Global error display widget
│       ├── snack_message.dart      # Snackbar helper (success/error/warning/info)
│       └── staggered_grid_view.dart# Staggered fade-in/slide-up grid animation
│
├── features/                       # Feature modules
│   ├── auth/                       # Authentication feature
│   │   ├── data/
│   │   │   ├── datasources/        # Remote & local auth data sources
│   │   │   ├── models/             # Auth model (JSON serializable)
│   │   │   └── repositories/       # Auth repository implementation
│   │   ├── domain/
│   │   │   ├── entities/           # User entity
│   │   │   ├── repositories/       # Auth repository abstract class
│   │   │   └── usecases/           # Login, Register use cases
│   │   └── presentation/
│   │       ├── bloc/               # AuthBloc (event → state)
│   │       └── pages/              # Login, Register pages
│   │
│   ├── home/                       # Products / Home feature
│   │   ├── data/
│   │   │   ├── datasources/        # Remote product data source
│   │   │   ├── models/             # Product model
│   │   │   └── repositories/       # Home repository implementation
│   │   ├── domain/
│   │   │   ├── entities/           # Product entity
│   │   │   ├── repositories/       # Home repository abstract class
│   │   │   └── usecases/           # Get products use case
│   │   └── presentation/
│   │       ├── bloc/               # HomeBloc (event → state)
│   │       ├── pages/              # Home, Product Detail pages
│   │       └── widgets/            # ProductCard, shimmer, grid
│   │
│   └── cart/                       # Shopping Cart feature
│       ├── data/
│       │   ├── datasources/        # Hive local data source
│       │   ├── models/             # Cart item model
│       │   └── repositories/       # Cart repository implementation
│       ├── domain/
│       │   ├── entities/           # Cart item entity
│       │   ├── repositories/       # Cart repository abstract class
│       │   └── usecases/           # Add/Remove/Get/Clear cart
│       └── presentation/
│           ├── bloc/               # CartBloc (event → state)
│           └── pages/              # Cart page with Lottie empty state
│
├── injection_container.dart        # GetIt DI configuration
└── main.dart                       # App entry point
```

---

## ✨ Features

### ✅ Implemented

- **User Authentication** — Login & registration with form validation
- **Product Catalog** — Browse products in a responsive grid with shimmer loading
- **Product Detail** — Full product info with Hero image transition & animated "Add to Cart"
- **Shopping Cart** — Manage items, quantities, order summary, with Lottie empty-state animation
- **Responsive Grid** — Adapts columns (2/3/4) based on screen width
- **Staggered Animations** — Cascading fade-in + slide-up for product grid items
- **Scale Animation** — Press-feedback animation on the "Add to Cart" button
- **Lottie Animation** — Engaging empty cart state with a looping Lottie animation
- **Global Error Widget** — Reusable `AppErrorWidget` for consistent error UIs
- **Snackbar System** — Typed `SnackMessage` helper (success, error, warning, info)
- **Dark Mode** — Full dark theme support
- **Error Handling** — Functional `Either` pattern with typed failure classes
- **Caching** — Product & cart data persisted locally with Hive
- **Network Awareness** — Offline detection with connectivity_plus

### 🔜 Planned

- [ ] Checkout flow (payment integration)
- [ ] User profile & order history
- [ ] Product search & filtering
- [ ] Push notifications
- [ ] Unit & widget tests
- [ ] CI/CD pipeline

---

## 📸 Screenshots

> *Coming soon — Generate screenshots from the running app.*

| Home Page | Product Detail | Cart Page | Cart Empty |
|-----------|---------------|-----------|------------|
| *Grid with staggered animations* | *Hero image + scale button* | *Items & order summary* | *Lottie animation* |

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.12+
- Dart 3.12+
- Android Studio / VS Code

### Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/fluxmarket.git
cd fluxmarket

# Install dependencies
flutter pub get

# Generate code (injectable, freezed)
dart run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

### Build for Production

```bash
# Android APK
flutter build apk --release

# iOS (requires macOS)
flutter build ios --release

# Web
flutter build web --release
```

---

## 🧪 Code Quality & Conventions

### Dart Style Guide

- **80-character line limit** for readability
- **PascalCase** for classes, enums, and type aliases
- **camelCase** for variables, methods, and parameters
- **SCREAMING_CASE** for constants
- **Trailing commas** for cleaner diffs
- **`const`** wherever possible for performance

### Architecture Rules

- ✅ BLoCs are **pure Dart** — no Flutter dependency
- ✅ Use cases encapsulate **single business operation**
- ✅ Repositories are **abstract** in domain, **concrete** in data
- ✅ Data sources return **models**; domain works with **entities**
- ✅ All cross-cutting concerns (theme, DI, networking) live in **core/**
- ✅ **No business logic** in widgets — only BLoC events & states

### Naming Conventions

- **Files**: `snake_case` (e.g., `product_card.dart`)
- **Types**: `PascalCase` (e.g., `ProductCard`)
- **Methods**: `camelCase` (e.g., `_buildProductGrid`)
- **Private**: Prefix with `_` (e.g., `_CartEmptyView`)
- **BLoC**: `XxxBloc`, `XxxEvent`, `XxxState`
- **Use Cases**: `VerbNounUsecase` (e.g., `GetProductsUsecase`)

---

## 🎬 Animations & UX

| Animation | Location | Implementation |
|-----------|----------|----------------|
| **Staggered Grid** | HomePage product grid | `StaggeredGridView` — sequential fade-in + slide-up with configurable delay |
| **Scale Button** | ProductDetailPage "Add to Cart" | `AnimationController` with `Tween(1.0 → 0.95)` for tactile feedback |
| **Lottie Empty Cart** | CartPage empty state | `Lottie.asset` with looping `empty_cart.json` animation |
| **Hero** | ProductCard → ProductDetailPage | Flutter's built-in `Hero` widget for smooth image transitions |
| **Shimmer Loading** | HomePage initial load | `shimmer` package with skeleton grid placeholders |

---

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Test Strategy

- **Unit Tests**: BLoCs, Use Cases, Repositories, DataSources
- **Widget Tests**: Pages, Widgets, custom components
- **Integration Tests**: Full feature flows

---

## 🗺 Roadmap

- [x] Project scaffolding & architecture setup
- [x] Core layer (networking, theme, error handling)
- [x] Authentication feature (login/register)
- [x] Product catalog & detail pages
- [x] Shopping cart with Hive persistence
- [x] Animations & UI polish
- [ ] Checkout & payment integration
- [ ] User profile management
- [ ] Order history tracking
- [ ] Product search & filtering
- [ ] Push notifications
- [ ] CI/CD with GitHub Actions
- [ ] Comprehensive test suite

---

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'feat: add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Commit Convention

We follow [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` — A new feature
- `fix:` — A bug fix
- `chore:` — Maintenance tasks
- `docs:` — Documentation changes
- `refactor:` — Code refactoring
- `test:` — Adding or updating tests
- `style:` — Code style changes (formatting, etc.)

---

## 📄 License

Distributed under the **MIT License**. See `LICENSE` for more information.

---

## 🙏 Acknowledgements

- [Clean Architecture by Robert C. Martin](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [BLoC Library](https://bloclibrary.dev) by Felix Angelov
- [Flutter](https://flutter.dev) team at Google
- All open-source packages used in this project

---

<p align="center">
  Made with ❤️ using Flutter & Clean Architecture
</p>