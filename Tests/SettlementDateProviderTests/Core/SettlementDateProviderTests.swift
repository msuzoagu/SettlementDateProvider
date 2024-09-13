// SettlementDateProviderTests.swift
// Created by msuzoagu on 9/13/24.

@testable import SettlementDateProvider
import XCTest

final class MockHolidayService: SettlementDateProcessor {
    var datesToReturn: [Date] = []

    func settlementDates() throws -> [Date] {
        return datesToReturn
    }
}

/** `SettlementDateProvider` is an integration point where the components
  HolidayService and DateValidator work together, it should focus on focus on how
 these components interact and ensure the overall behavior is correct.

 Implement 2 Types of test for SettlementDateProvider:
 • Integration Testing:
  - mock HolidayService and other dependencies to isolate and test the logic within SettlementDateProvider.
  - verify that SettlementDateProvider correctly calculates adjusted settlement dates based on different
  strategies and payment dates.

 • End-to-End Testing:
  - use real instances of HolidayService to test the SettlementDateProvider in a fully integrated environment.
  - ensure correct calculation of settlement dates when taking into account real holiday data and payment dates.
  - test different combinations of SettlementStrategy and PaymentDates to ensure robustness.
  */
final class SettlementDateProviderTests: XCTestCase {
    struct TestData {
        let input: (
            strategy: SettlementStrategy,
            paymentDates: [Date],
            holidaySerive: MockHolidayService
        )
        let expectedOutput: [Date]
    }

    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}

    func testExample() throws {}

    func testPerformanceExample() throws {
        measure {}
    }
}
