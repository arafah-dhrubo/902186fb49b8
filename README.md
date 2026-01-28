# Device Vital Monitor

A full-stack application built for the SE 1 Take-Home Assignment. This project monitors device vitals (Thermal State, Battery Level, and Memory Usage) and logs them to a persistent backend.

## 🚀 Quick Start

### 1. Prerequisites
- **Flutter SDK**: 3.27.1
- **Node.js**: ^18.x
- **Xcode**: 15.0+ (iOS 13.0+)
- **Android SDK**: Min 21, Target 34

### 2. Setup Backend (Node.js)
```bash
cd api
npm install
node server.js
```
The server will start at `http://localhost:8000`. It uses SQLite for persistence. Find the `api_constants.dart` file in the app directory to configure the API endpoint if needed.

### 3. Setup App (Flutter)
```bash
cd app
# If first time, link native dependencies
cd ios && pod install && cd ..
# Run the app
flutter run
```
---

## Platforms
- **iOS**: Tested on iPhone 14 Pro (Physical), iPhone 15 Pro Max (Physical), iPhone 16
- **Android**: Tested on Pixel 9 Pro, Realme X (Physical), Redmi note 10 Pro (Physical)
---

## Tech Stack

### App (Flutter)
- **State Management**: `flutter_bloc` (Cubits)
- **Architecture**: Repository Pattern
- **Networking**: `Dio` with custom interceptors/error handling
- **Native Interop**: Custom `MethodChannels` for Thermal, Battery, and Memory (no 3rd party plugins used).

### Backend (Node.js)
- **Framework**: Express.js
- **Database**: SQLite3 (Persistence)
- **Analytics**: Optimized SQL aggregations for rolling averages.

---

## Project Structure
- `/app`: Flutter application source code.
- `/api`: Node.js Express API source code.
- `/DECISIONS.md`: Documentation of ambiguities and design choices.
- `/ai_log.md`: Collaboration log between the engineer and AI.
- `/README.md`: This file.

---

## Key Features
- **Real-time Monitoring**: Vitals refresh every 5 seconds on the Dashboard.
- **Save to Cloud**: Manual logging with instant persistence.
- **Analytics Dashboard**: View rolling averages and historical trends.
- **Connectivity Status**: Real-time banner alerts for offline/online states.
- **Human-Centric UI**: A bespoke, professional theme (Red/Black/White) with custom components.

## Testing
- **Backend**: Run `node test.js` in `/api`.
- **Frontend**: Run `flutter test` in `/app`.

---

> [!IMPORTANT]
> This project was done on a device that has all the latest SDKs installed. Old SDKs may not work. If not working, please update the SDKs to the latest version.

