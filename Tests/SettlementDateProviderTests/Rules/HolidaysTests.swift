// HolidaysTests.swift
// Created by msuzoagu on 9/12/24.

@testable import SettlementDateProvider
import XCTest

final class HolidaysTest: XCTestCase {
    func testExample() throws {
        let decoder = JSONDecoder()
        let holidays = try decoder.decode(Holidays.self, from: validJSON)
        XCTAssertEqual(holidays.rules.count, 11, "there should be 11 US bank holiday rules")
    }
}
