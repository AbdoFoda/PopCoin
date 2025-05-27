# 📲 Bitcoin Price Tracker (SwiftUI)

This is a SwiftUI-based app that displays Bitcoin's price in multiple currencies, along with historical data. It uses the [CoinGecko API](https://www.coingecko.com/en/api/documentation) and is built with testability and modularity in mind.

---

## ✨ Features

- ✅ Shows today's Bitcoin price in EUR, USD, GBP, and more
- 📉 Displays 14-day historical price data
- 🔄 Auto-refreshes every 60 seconds
- 📦 Built with protocol-oriented, modular architecture
- 🧪 Includes full unit and integration tests

---

## 🚀 How to Run the App

### 1. Requirements

- macOS 13 or later
- Xcode 15 or later
- iOS 16 deployment target

### 2. Setup Instructions

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/bitcoin-price-tracker.git
   cd bitcoin-price-tracker
2. Open the project in Xcode:
   ```bash
   open BitcoinPriceTracker.xcodeproj
3. Build and run the app using the simulator or a connected device.

⚠️ No third-party dependencies are used. The app is built entirely using Swift, SwiftUI, Combine, and URLSession.

🧪 Running Tests
Open the project in Xcode

Press Cmd + U to run all tests

The test suite includes:

✅ Unit tests for all ViewModels and services

✅ Integration tests for API and service layers

❌ Snapshot testing is skipped to avoid third-party dependencies

🧠 Architecture Overview
The app is organized using clean architecture principles:

🧱 Layers
Presentation

```bash
BitcoinPriceListViewModel and PriceDetailsViewModel

SwiftUI views

Service Layer

FetchPriceService: Formats and filters raw data

HistoricalPriceService: Normalizes historical API data

Network Layer

CoinGeckoAPI: Encapsulates all network logic

FetchPriceRepo & HistoricalPricesRepo protocols for abstraction

```


🔄 Flow

```bash
[SwiftUI View]
     ↓
[ViewModel (MainActor)]
     ↓
[Service]
     ↓
[Repo (API client)]
```
All async operations are await-based and executed on appropriate actors.

🔐 CoinGecko API Key
The app uses a free demo key from CoinGecko. This allows up to 50 requests per minute. No setup is needed.

Clean architecture and separation of concerns

Protocol-oriented programming and testability

SwiftUI best practices with @MainActor, @Published, and dependency injection

Integration with a public API

Real-time updates using a Timer.publish stream

Modular, scalable structure ready for future extension (e.g. other coins, chart rendering)

📎 License
This project is open-source and provided for educational and technical evaluation purposes.









