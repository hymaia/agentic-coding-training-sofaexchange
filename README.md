# SofaExchange

Browse sofa listings across European cities. Filter by city, price, sofa type, and free WiFi.

---

## Monorepo structure

```
sofaexchange/
├── contracts/openapi.yaml   # Single source of truth for all API types
├── apps/api/                # NestJS backend
├── apps/web/                # React web app
├── apps/ios/                # iOS app (UIKit)
└── apps/android/            # Android app (Kotlin Views)
```

---

## Getting Started

Install dependencies once from the repo root:

```bash
npm install
```

Launch the backend API server:

```bash
npm run dev:api              # http://localhost:3000
```

Launch the web app (in a second terminal):

```bash
npm run dev:web              # http://localhost:5173
```

Launch the iOS app:

```bash
open apps/ios
```

Then run the `SofaExchange` scheme from Xcode on a simulator (iOS 16+).

Launch the Android app:

```bash
cd apps/android
./gradlew installDebug
```

Then start it from Android Studio or an attached emulator/device (API 26+).

---

## API — `apps/api`

**Stack**: NestJS · better-sqlite3 · TypeScript

**Architecture**: Clean Architecture — `domain` → `application` → `infrastructure` → `presentation`

**Endpoint**: `GET /listings`

| Query param | Type | Description |
|---|---|---|
| `city` | `City[]` | Repeat for multiple: `?city=LONDON&city=PARIS` |
| `minPriceCents` | `integer ≥ 0` | Min price per night in cents |
| `maxPriceCents` | `integer ≥ 0` | Max price per night in cents |
| `hasFreeWifi` | `boolean` | Filter to free-WiFi listings |
| `sofaType` | `SOFA_BED \| SIMPLE_SOFA` | Filter by sofa type |

Returns a flat `Listing[]` array.

**Getting started**

```bash
cd apps/api
npm install
cp .env.example .env
npm run start:dev          # http://localhost:3000
```

The database is created and seeded automatically on first boot.

**Tests**: `npm test`

---

## Web — `apps/web`

**Stack**: React 18 · Vite · SWR · TypeScript

**Architecture**: Clean Architecture — `domain` → `application` → `infrastructure` → `presentation`

Search form with city multi-select, price range inputs (in euros, stored as cents), sofa type selector, and WiFi toggle. Results update automatically on filter change via SWR.

**Getting started**

```bash
cd apps/web
npm install
npm run dev                # http://localhost:5173
```

**Tests**: `npm test`

---

## iOS — `apps/ios`

**Stack**: UIKit · Alamofire · Swift · Swift Package Manager

**Architecture**: Clean Architecture — `Domain` / `Data` / `Presentation`

**Minimum deployment target**: iOS 16

**Getting started**

1. Open `apps/ios` in Xcode
2. Xcode resolves Alamofire automatically via SPM
3. Select an iOS simulator and run

To build from the command line (against the iOS simulator SDK):

```bash
cd apps/ios
swift package resolve
swift build \
  -Xswiftc "-sdk" -Xswiftc "$(xcrun --sdk iphonesimulator --show-sdk-path)" \
  -Xswiftc "-target" -Xswiftc "arm64-apple-ios16.0-simulator" \
  -Xcc "-isysroot" -Xcc "$(xcrun --sdk iphonesimulator --show-sdk-path)" \
  -Xcc "-target" -Xcc "arm64-apple-ios16.0-simulator"
```

**Tests**: run the `SofaExchangeTests` scheme in Xcode

---

## Android — `apps/android`

**Stack**: Kotlin · Views/XML · Retrofit · Moshi · LiveData · Gradle (Kotlin DSL)

**Architecture**: Clean Architecture — `domain` / `data` / `presentation`

**Minimum SDK**: 26 (Android 8.0)

> The emulator connects to the backend via `http://10.0.2.2:3000` (the standard Android emulator alias for host `localhost`).

**Getting started**

1. Open `apps/android` in Android Studio
2. Let Gradle sync
3. Run on an emulator (API 26+)

From the command line:

```bash
cd apps/android
./gradlew assembleDebug
```

**Tests**: `./gradlew test`

---

## Enums (shared across all tiers)

**City** — `LONDON` · `PARIS` · `MILAN` · `MADRID` · `LISBON` · `BERLIN` · `DUBLIN` · `EDINBURGH` · `VIENNA`

**SofaType** — `SOFA_BED` · `SIMPLE_SOFA`

The canonical definitions live in `contracts/openapi.yaml`. All four apps mirror these values exactly.
