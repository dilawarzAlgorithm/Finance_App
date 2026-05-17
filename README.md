## Finance App — Local-First Expense Tracker

A high-performance, local-first Finance and Expense Tracker built with Flutter. The application leverages a relational SQLite local storage engine, executes clean data aggregation through platform-independent domain math, and renders beautifully animated charts directly on the GPU using low-level Canvas primitives (`CustomPainter`).

Built using strict layered architecture patterns and robust, reusable custom graphics, this app avoids standard third-party charting packages to maintain total creative control, high performance, and smooth animations.

## Key Technical Features

- **Offline-First & Relational Architecture**: Built with `sqflite` using true relational integrity, relational constraints (`FOREIGN KEY` with `ON DELETE RESTRICT`), and automated schema seeding.

- **Low-Level GPU Drawing (`CustomPainter`)**: Custom-made animated financial visualizers:
  - **The Donut Spending Chart**: Renders math-based arc slices using the geometric `pi` constant and overlays a center-mask for a donut effect.

  - **The Ratio Bar**: A dynamic horizontal double-sided pill bar representing income vs. expenses side-by-side using rounded rectangles.

- **Reactive UI & Clean State Management**: Navigational futures and state checks (`mounted`) keep UI states synchronized immediately upon pops/returns.

- **Dynamic Category Management**: Serialization of rich Flutter models into standard relational schemas. Category hex color strings and icon glyph code points are stored inside SQLite and parsed back at runtime.

- **Gestural Interaction & Fluid UX**: Drag-down to refresh utilizing `RefreshIndicator` with forced scroll physics, combined with `Dismissible` swiping for safe, multi-step transaction deletion.

## System Architecture & Separation of Concerns

To avoid the bloating of widget classes with core business rules, the codebase strictly decouples its operations:

```bash
lib/
├── core/
│   ├── data/
│   │   └── models/            # Type-safe Category & Transaction data models
│   ├── database/
│   │   └── database_helper.dart # Relational SQLite layer (Singleton pattern)
│   └── services/
│       └── finance_calculator.dart # Pure Dart service for mathematical logic
├── screens/
│   ├── add_category.dart      # Custom category creation screen
│   ├── add_transaction.dart   # Interactive transactional input form
│   └── dashboard.dart         # Multi-tab view container & navigation orchestrator
├── theme/
│   └── theme.dart             # Modular theme design tokens
└── widgets/
    ├── app_drawer.dart        # Main app navigation drawer
    ├── transactions.dart      # Relational list view with Swipe-to-Dismiss action
    ├── analytics.dart         # Pull-to-refresh analytics and chart page
    └── charts/
        ├── finance_chart_painter.dart     # Custom circular donut chart
        └── summary_bar_chart_painter.dart # Custom horizontal comparison pill
```

## Solved Architectural Obstacles

1. **Tab Rebuild & Const Optimization**

- **Issue**: Widgets declared as `const` within navigation tables skipped lifecycle updates when returning from transaction creation forms.

- **Solution**: Removed hardcoded static optimizations and unified navigation pathways to await returns asynchronously, forcing target states to trigger data re-fetching.

2. **Model Serialization**

- **Issue**: Standard databases cannot store Flutter classes like `Color` or `IconData` natively.

- **Solution**: Serialized colors to hex strings (e.g., `#4CAF50`) and icon representations to integer values (`iconCodePoint`), mapping them back dynamically inside category model factories.

## Database Schema & Relational Structure

**Categories Table**

|  Column   | SQL Type |         Modifiers         |
| :-------: | :------: | :-----------------------: |
|    id     | INTEGER  | PRIMARY KEY AUTOINCREMENT |
|   name    |   TEXT   |         NOT NULL          |
|   color   |   TEXT   |    NOT NULL (Hex Code)    |
| icon_path |   TEXT   |   NOT NULL (Asset Path)   |

**Transactions Table**

|   Column    | SQL Type |                    Modifiers                    |
| :---------: | :------: | :---------------------------------------------: |
|     id      | INTEGER  |            PRIMARY KEY AUTOINCREMENT            |
|    title    |   TEXT   |                    NOT NULL                     |
|   amount    |   REAL   |                    NOT NULL                     |
|    date     |   TEXT   |            NOT NULL (ISO8601 String)            |
|    type     |   TEXT   |              NOT NULL (Enum Name)               |
| category_id | INTEGER  | NOT NULL, FOREIGN KEY REFERENCES categories(id) |

## Getting Started & Local Setup

**Prerequisites**

- Flutter SDK (v3.10+ recommended)

- Dart SDK (compatible with targeted Flutter engine)

**Step-by-Step Installation**

1. **Clone the Repository**:

```bash
git clone https://github.com/dilawarzAlgorithm/Finance_App.git
cd finance_app
```

2. **Install Dependencies**:

```bash
flutter pub get
```

3. **Run Code Generation / Verification**:

```bash
flutter analyze
```

4. **Run the Application**:

- For physical devices or virtual simulators:

```bash
flutter run
```
