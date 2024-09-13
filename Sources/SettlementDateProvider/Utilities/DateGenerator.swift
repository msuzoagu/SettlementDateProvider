// DateGenerator.swift
// Created by msuzoagu on 9/13/24.

import Foundation

/** A utility struct for generating dates from various bank holiday rule formats. */
enum DateGenerator {
    enum GeneratorError: Error {
        case invalidDate(msg: String)
        case monthdayNotFound(msg: String)
        case missingDynamicDateComponents(msg: String)
        case invalidComponentConversion(msg: String)
    }

    /** Generates a fixed date from a month-day string.
     - Parameters:
      - monthDay: The month-day string (e.g., "12-25").
      - validator: The `DateValidator` used to validate and generate the date.
     - Throws: `HolidayDateGeneratorError.invalidDate` if the date cannot be generated.
     - Returns: A `Date` object corresponding to the month-day.
     */
    static func fixedDate(from monthDay: String) throws -> Date {
        let validator = DateValidator()
        guard let date = validator.generateDateFrom(monthDayString: monthDay) else {
            throw GeneratorError.invalidDate(msg: "Invalid monthDay: \(monthDay)")
        }
        return date
    }

    /** Generates a dynamic date based on week, weekday, and month components.
     - Parameters:
      - week: The week of the month (e.g., 1st, 2nd).
      - weekDay: The day of the week (e.g., Monday, Tuesday).
      - month: The month of the year (e.g., January, February).
      - validator: The `DateValidator` used to validate and generate the date.
     - Throws: `HolidayDateGeneratorError.invalidDate` if the date cannot be generated.
     - Returns: A `Date` object corresponding to the dynamic date components.
     */
    static func dynamicDate(week: Int, weekDay: Int, month: Int) throws -> Date {
        let validator = DateValidator()
        guard let date = validator.generateDateFrom(weekDay: weekDay, week: week, month: month) else {
            throw GeneratorError.invalidDate(msg: "Invalid dynamic date components")
        }
        return date
    }
}
