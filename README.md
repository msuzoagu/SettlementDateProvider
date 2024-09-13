# SettlementDateProvider

## Package Overview
SettlementDateProvider is a Swift package designed to caluclate and provide accurate settlement dates by considering country-specific bank holidays and weekends.

The package includes embedded holiday rules for supported countries, ensuring that payments and other financial transactions are processed on valid business days without requiring external configuration.

## Installation
To add *SettlementDateProvider* to your project, include it in your `Package.swift` file:
```swift
dependencies: [
    .package(url: "https://github.com/msuzoagu/SettlementDateProvider.git", from: "1.0.0")
]
```
You can also use Xcode's GUI to add the package dependency

## Sample Usage
```swift
import SettlementDateProvider

let strategy: SettlementStrategy = .restrictive
let provider = try SettlementDateFactory().provider(
    for: "US",
    using: strategy,
    given: [Date()]
)
let settlementDates = provider.settlementDates
```

```swift
import SettlementDateProvider

let provider = try SettlementDateFactory().provider(
    for: "US",
    given: [Date()]
)
let settlementDates = provider.settlementDates
```

## Getting Started
To use *SettlementDateProvider*, you need to provide:
- __a country code__
   - where - **country code** must be `iSO 3166-1 alpha 2` format
- __a date list__
   - where __date list__ is `[Date]` you want to generate settlement dates
- __a settlement strategy__
   - SettlementDateProvider offers flexible strategies for determining the settlement date via`SettlementStrategy` enum:
      - permissive: selects closest previous valid business day before reference
        date
      - restrictive: selects next valid business day after reference date
> `SettlementStrategy` defaults to `.permissive`


## Supported Countries
   - United States
      - `iSO 3166-1 alpha 2` format **"US"**
