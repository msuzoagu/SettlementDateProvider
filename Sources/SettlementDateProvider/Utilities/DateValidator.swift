// DateValidator.swift
// Created by msuzoagu on 9/13/24.

import Foundation

enum DateValidatorError: Error {
    case invalidDayInt(msg: String)
    case invalidMonthInt(msg: String)
    case invalidYearInt(msg: String)
    case invalidMonthDay(msg: String)
}

class DateValidator {
    var calendar: Calendar

    @available(iOS 15, *)
    var currentYear: Int {
        return calendar.component(.year, from: Date())
    }

    init() {
        self.calendar = Calendar.autoupdatingCurrent
    }

    // MARK: Internal Methods

    /** Generates a `Date` from a string in "Month Day" format (e.g., "January 13").
      - Parameter monthDayString: The month and day string.
     - Returns: A `Date` object if the conversion is successful, otherwise `nil
      */
    func generateDateFrom(monthDayString: String) -> Date? {
        guard let isoString = isoStringFrom(monthDayString: monthDayString) else {
            return nil
        }

        guard let isoDate = isoDateFrom(isoDateString: isoString) else {
            return nil
        }
        return isoDate
    }

    /** Generates a `Date` from weekday, week, and month given as Ints
     - Parameters:
      - weekDay: The week day (1 for Sunday, 2 for Monday, ..., 7 for Saturday).
      - week: The week number (-1 for last week, 1 for first week, ..., 4 for fourth week).
      - month: The month number (1 for January, ..., 12 for December).
     - Returns: A `Date` object if the conversion is successful, otherwise `nil`.
      */
    func generateDateFrom(weekDay: Int, week: Int, month: Int) -> Date? {
        @available(iOS 15, *)
        let currentYear = calendar.component(.year, from: Date())
        guard weekDay >= 1, weekDay <= 7 else { return nil }
        guard month >= 1, month <= 12 else { return nil }
        guard week >= -1, week <= 4 else { return nil }

        var components = DateComponents()
        components.weekday = weekDay
        components.month = month
        components.year = currentYear
        components.weekdayOrdinal = week
        components.timeZone = TimeZone.autoupdatingCurrent

        guard let date = calendar.date(from: components) else { return nil }
        return date
    }

    /** Generate a `Date` from day, month, and year given as Strings
     - Parameters:
     - `day`: the day as string (can be any string value 1...31)
     - `month`: the month as  string (can be any string value 1...12)
     - `year`: the year as string (e.g. "1999", "2023")
      */
    func generateDateFrom(day: String, mo: String, yr: String) throws -> Date? {
        let dayInt = try validateAsInt(day: day)
        let monthInt = try validateAsInt(month: mo)
        let yearInt = try validateAsInt(year: yr)

        var components = DateComponents()
        components.day = dayInt
        components.month = monthInt
        components.year = yearInt
        components.timeZone = TimeZone.autoupdatingCurrent

        guard let date = calendar.date(from: components) else { return nil }
        return date
    }

    /** Determines the settlement date based on the provided strategy.
      - Parameters:
        - nextDay: The next available business day after the reference date.
        - previousDay: The previous available business day before the reference date.
        - strategy: The strategy used to determine the settlement date, which can be:
          - `.permissive`: Selects the `previousDay`.
          - `.restrictive`: Selects the `nextDay`.
          - `nil`: Defaults to selecting the `nextDay`.
      - Returns: The selected settlement date based on the provided strategy.
      - Note: This method assumes that `nextDay` and `previousDay` are valid business days surrounding a reference date.
     */
    func selectBetween(nextDay: Date, previousDay: Date, using strategy: SettlementStrategy) -> Date {
        switch strategy {
        case .permissive:
            return previousDay /// get money a day or more earlier
        case .restrictive:
            return nextDay
        }
    }

    // MARK: - Private Properties

    /// ISO 8601 date formatter; enables conversion from monthDay strings ("March 12") to isoStrings.
    /// isoStrings convert into date obj's that respect the user's locale
    private lazy var isoFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone.autoupdatingCurrent
        formatter.formatOptions = [.withFullDate]
        return formatter
    }()

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = .autoupdatingCurrent
        formatter.timeZone = .autoupdatingCurrent
        formatter.calendar = calendar
        return formatter
    }()

    // MARK: - Private Methods=

    /** Converts a "Month Day" string to an ISO date string.
     - Parameter monthDayString: The month and day string.
     - Returns: An ISO date string if the conversion is successful, otherwise `nil`
     */
    private func isoStringFrom(monthDayString: String) -> String? {
        let months = [
            "January": "01", "February": "02", "March": "03",
            "April": "04", "May": "05", "June": "06",
            "July": "07", "August": "08", "September": "09",
            "October": "10", "November": "11", "December": "12",
        ]

        let components = monthDayString.split(separator: " ")

        guard components.count == 2,
              let month = months[String(components[0])],
              let day = Int(components[1])
        else {
            return nil
        }

        let formattedDay = String(format: "%02d", day)
        return "\(currentYear)-\(month)-\(formattedDay)"
    }

    /** Converts an ISO date string to a `Date` object.
     - Parameter isoDateString: The ISO date string.
     - Returns: A `Date` object if the conversion is successful, otherwise `nil`
     */
    private func isoDateFrom(isoDateString: String?) -> Date? {
        guard isoDateString != nil else { return nil }
        let formatter = isoFormatter
        guard let date = formatter.date(from: isoDateString!) else { return nil }
        return date
    }

    private func validateAsInt(day: String) throws -> Int {
        guard let dayInt = Int(day), dayInt >= 1 && dayInt <= 31 else {
            throw DateValidatorError.invalidDayInt(
                msg: "\(day) is invalid as String: must be 1...31"
            )
        }
        return dayInt
    }

    private func validateAsInt(month: String) throws -> Int {
        guard let monthInt = Int(month), monthInt >= 1 && monthInt <= 12 else {
            throw DateValidatorError.invalidMonthInt(
                msg: "\(month) is invalid as String: must be 1...12"
            )
        }
        return monthInt
    }

    private func validateAsInt(year: String) throws -> Int {
        guard let yearInt = Int(year), yearInt >= currentYear else {
            throw DateValidatorError.invalidYearInt(
                msg: "\(year) must be >= currentYear: \(currentYear)"
            )
        }
        return yearInt
    }
}
