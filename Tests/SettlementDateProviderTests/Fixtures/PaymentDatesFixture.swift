// PaymentDatesFixture.swift
// Created by msuzoagu on 9/12/24.

import Foundation
@testable import SettlementDateProvider

struct PaymentDatesFixture {
    private let dateValidator = DateValidator()

    enum Payperiod: Int {
        case weekly = 7
        case biweekly = 14
        case semiweekly = 15
        case monthly = 1

        var interval: DateComponents {
            switch self {
            case .weekly:
                return DateComponents(day: rawValue)
            case .biweekly:
                return DateComponents(day: rawValue)
            case .semiweekly:
                return DateComponents(day: rawValue)
            case .monthly:
                return DateComponents(month: rawValue)
            }
        }
    }

    func generatePayDates(day: String, month: String, year: String, for payPeriod: Payperiod) throws -> [Date] {
        return try datesFrom(day: day, month: month, year: year, for: payPeriod)
    }

    private func datesFrom(day: String, month: String, year: String, for payPeriod: Payperiod) throws -> [Date] {
        guard let startDate = try dateValidator.generateDateFrom(day: day, mo: month, yr: year) else { return [] }

        var dates = [Date]()
        let calendar = dateValidator.calendar
        var currentDate = startDate

        let endOfYear = calendar.date(
            from: DateComponents(
                year: calendar.component(.year, from: startDate), month: 12, day: 31
            )
        )!

        while currentDate <= endOfYear {
            dates.append(currentDate)
            if let nextDate = calendar.date(byAdding: payPeriod.interval, to: currentDate) {
                currentDate = nextDate
            } else { break }
        }
        return dates
    }
}
