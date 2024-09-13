// HolidayDateFixture.swift
// Created by msuzoagu on 9/13/24.

import Foundation
@testable import SettlementDateProvider

/** Fixture used to generate a predefined list of holiday dates to simulate holidayDates for testing purposes. */
class HolidayDateFixture {
    enum HolidayDateFixtureError: Error {
        case invalidDateFormat(msg: String)
    }

    private let country: String
    private let dateValidator: DateValidator

    init(country: String) {
        self.country = country
        self.dateValidator = DateValidator()
    }

    func loadHolidayDates() throws -> [Date] {
        switch country {
        case "US":
            return try usDates()
        default:
            return []
        }
    }

    func usDates() throws -> [Date] {
        let dates = try usStrings.map { str -> Date in
            let strArray = str.split(separator: "/")
            if strArray.count == 3 {
                let yr = String(strArray[0])
                let month = String(strArray[1])
                let day = String(strArray[2])
                return try dateValidator.generateDateFrom(day: day, mo: month, yr: yr)!
            } else {
                throw HolidayDateFixtureError.invalidDateFormat(
                    msg: "invalid date formate in HolidayDateFixture"
                )
            }
        }
        return dates
    }

    private var usStrings: [String] {
        [
            "2024/01/01", // New Year's Day
            "2024/01/15", // MLK Jr. Day
            "2024/02/19", // Presidents' Day
            "2024/05/27", // Memorial Day
            "2024/06/19", // Juneteenth
            "2024/07/04", // Independence Day
            "2024/09/02", // Labor Day
            "2024/10/14", // Columbus Day
            "2024/11/11", // Veterans Day
            "2024/11/28", // Thanksgiving Day
            "2024/12/25", // Christmas Day
        ]
    }
}
