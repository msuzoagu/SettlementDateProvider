// SettlementDateProvider.swift
// Created by msuzoagu on 9/13/24.

import Foundation

public class SettlementDateProvider: SettlementDateProcessor {
    private let strategy: SettlementStrategy
    private let paymentDates: [Date]
    private var holidayDates: [Date] = []
    private let dateValidator: DateValidator
    private let holidayService: HolidayService

    init(strategy: SettlementStrategy, paymentDates: [Date], holidayService: HolidayService) {
        self.strategy = strategy
        self.paymentDates = paymentDates
        self.dateValidator = DateValidator()
        self.holidayService = holidayService
    }

    // MARK: - Public Methods

    /** Calculates and returns the adjusted settlement dates for the provided payment dates, taking into account holidays and weekends.
     - Returns `[Date]`:  An array of Date objects representing actual dates of settlement
     - Throws: error if there is an issue retrieving holiday dates from`HolidayDatesProvider`.
      */
    public func settlementDates() throws -> [Date] {
        holidayDates = try holidayService.holidayDates()

        return paymentDates.reduce(into: [Date]()) { array, paymentDate in
            if isHoliday(paymentDate) {
                if let validDate = selectClosestBusinessDay(to: paymentDate, using: strategy) {
                    array.append(validDate)
                }
            } else {
                array.append(paymentDate)
            }
        }
    }

    // MARK: - Private Methods

    /** Determines if given payment date falls on a Holiday
     - Parameter paymentDate:the date to check
     - Returns: `true` if paymentDate is a holiday; `false` otherwise
      */
    private func isHoliday(_ paymentDate: Date) -> Bool {
        return holidayDates.contains(paymentDate)
    }

    /** Finds the closest valid business day to the provided paymentDate, adjusting for holidays and weekends
      - Parameter date: the payment date
     - Returns: The closest valid business day as a `Date` object, or `nil` if no such date can be found.
      */
    private func selectClosestBusinessDay(to date: Date, using strategy: SettlementStrategy) -> Date? {
        guard let nextDate = nextBusinessDay(after: date) else { return nil }
        guard let previousDate = previousBusinessDay(before: date) else { return nil }
        return dateValidator.selectBetween(nextDay: nextDate, previousDay: previousDate, using: strategy)
    }

    /** Finds the next valid business day after the given date, skipping holidays and weekends.
     - Parameter date: The date from which to find the next business day.
     - Returns: The next business day after the given date, or `nil` if no such date can be found.
     */
    private func nextBusinessDay(after paymentDate: Date) -> Date? {
        var nextDate = dateValidator.calendar.date(
            byAdding: .day, value: 1, to: paymentDate
        )

        while let unwrappedNextDay = nextDate {
            if !isHolidayOrWeekend(unwrappedNextDay) { return unwrappedNextDay }
            nextDate = dateValidator.calendar.date(byAdding: .day, value: 1, to: unwrappedNextDay)
        }

        return nil
    }

    /** Determines whether the given date is either a holiday or falls on a weekend.
     - Parameter date: The date to check.
     - Returns: `true` if the date is a holiday or falls on a weekend, `false` otherwise.
     */
    private func isHolidayOrWeekend(_ paymentDate: Date) -> Bool {
        return isHoliday(paymentDate) || dateValidator.calendar.isDateInWeekend(paymentDate)
    }

    /** Finds the previous valid business day before the given date, skipping holidays and weekends.
     - Parameter date: The date from which to find the previous business day.
     - Returns: The previous business day before the given date, or `nil` if no such date can be found.
     */
    private func previousBusinessDay(before paymentDate: Date) -> Date? {
        var previousDate = dateValidator.calendar.date(byAdding: .day, value: -1, to: paymentDate)!
        while isHolidayOrWeekend(previousDate) {
            previousDate = dateValidator.calendar.date(
                byAdding: .day, value: -1, to: previousDate
            )!
        }
        return previousDate
    }
}
