
# 📈 Replay Trader

Replay Trader is a market simulation and trading practice application that allows users to experience historical market movements in a risk-free environment. Users can explore historical price data, replay market candles step by step, execute simulated trades, and evaluate their trading performance through detailed analytics and statistics.

## Key Features & Development Contributions

### 1. Historical Market Data Management
- Prepared and organized historical price data into smaller, optimized files for CDN delivery.
- Structured candle-based market data for efficient loading and replay.

### 2. Trading Replay Engine & Interactive Charts
- Developed the candle-by-candle market replay engine.
- Integrated interactive charts to visualize historical price movements.
- Implemented chart-related functionality using Flutter-based charting packages.

### 3. Simulated Trading & Broker System
- Built a simulated broker system for placing and managing trades.
- Implemented order execution, trade fills, balance management, and portfolio calculations.
- Enabled users to practice trading without using real money.

### 4. Mathematical & Financial Calculations
- Developed custom Dart-based calculation logic and utilized mathematical packages for trading-related computations.
- Implemented calculations for trade execution, profit and loss (P&L), account balance, performance metrics, and trading statistics.
- Integrated calculation results into the trading interface and analytics.

### 5. Trading Sessions, Journal & Performance Analytics
- Implemented trading session management and trade journaling.
- Developed statistical features to track trading activity and evaluate user performance.
- Organized trade history and performance data for review.

### 6. Authentication & Account Management
- Integrated sign-in and authentication methods.
- Developed account-related screens and user management functionality.

### 7. Subscription Plans & Billing
- Designed and developed subscription plan screens.
- Implemented plan-related functionality and billing flow integration.

## Technology & Development

- **Framework:** Flutter
- **Programming Language:** Dart
- **Packages:** Flutter and Dart packages for chart visualization, mathematical calculations, authentication, and application functionality.
- **Core Areas:** Data processing, financial calculations, interactive charting, simulated trading logic, authentication, subscription management, and performance analytics.

## Getting Started

### Clone the Repository

```bash
git clone https://github.com/your-username/replay-trader.git
```

### Navigate to the Project Directory

```bash
cd replay-trader
```

### Install Dependencies

```bash
flutter pub get
```

### Run the Application

```bash
flutter run
```


This project is licensed under the MIT License.
