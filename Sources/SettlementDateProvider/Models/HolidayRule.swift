// HolidayRule.swift
// Created by msuzoagu on 9/13/24.

import Foundation

/** `HolidayRule` is a structure that represents a rule for determining a
  holiday date. This structure supports two types of holidays: fixed and dynamic.

  - A `fixed` holiday has a specific date each year, such as "January 1st".
  - A `dynamic` holiday's date varies based on rules, such as "the first Monday in September".

  The rules for each type are enforced as follows:
  - `Fixed Holiday:`
     - Must provide a `name` and `monthDay`.
     - The `month` and `week` and `weekDay` should be `nil`.
  - `Dynamic Holiday:`
     - Must provide a `name`, `month`, `week`, and `weekDay`.
     - The `monthDay` should be `nil`.

  ## Example Usage:
  ```json
    // Fixed Holiday Example (New Year's Day)
   {
     "name": "New Year's Day",
     "monthDay": "January 1",
     "type": "fixed"
   }

     // Dynamic Holiday Example (Labor Day)
   {
     "name": "Labor Day",
     "month": "September",
     "week": "1",
     "weekDay": "Monday",
     "type": "dynamic"
    }
 ```

  ## Fields:
  - `name`: The name of the holiday (e.g., "New Year's Day", "Labor Day").
     - Required always
  - `month`: The month in which the holiday occurs.
     - Required for dynamic holidays; `nil` for fixed holidays.
  - `week`: The week of the month in which the holiday occurs (e.g., "first", "last").
     - Required for dynamic holidays; `nil` for fixed holidays.
  - `weekDay`: The day of the week on which the holiday occurs (e.g., "Monday", "Friday").
     - Required for dynamic holidays; `nil` for fixed holidays.
  - `monthDay`: The specific day of the month (e.g., "January 1").
     - Required for fixed holidays; `nil` for dynamic holidays.
  - `type`: The type of holiday (`fixed` or `dynamic`); determines which fields are required or `nil`.
     - Required always */

struct HolidayRule: Decodable {
    let name: String
    let month: String? // Optional; required only for dynamic holidays.
    let week: Week? // Optional; required only for dynamic holidays.
    let weekDay: WeekDay? // Optional; required only for dynamic holidays.
    let monthDay: String? // Optional; required only for fixed holidays
    let type: HolidayType

    enum Week: String, Decodable {
        case first = "1"
        case second = "2"
        case third = "3"
        case fourth = "4"
        case last
    }

    enum WeekDay: String, Decodable {
        case monday = "Monday"
        case tuesday = "Tuesday"
        case wednesday = "Wednesday"
        case thursday = "Thursday"
        case friday = "Friday"
        case saturday = "Saturday"
        case sunday = "Sunday"
    }

    enum HolidayType: String, Decodable {
        case fixed
        case dynamic
    }

    enum CodingKeys: CodingKey {
        case name
        case month
        case week
        case weekDay
        case monthDay
        case type
    }

    /** Initializes a new `HolidayRule` instance;  enforces the rules for fixed vs dynamic holidays based on the value of `type`
     - Parameter decoder: the decoder to read data from
     - Throws: custom `CodableError` if any required field is missing or if data is otherwise invalid
     */
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.name = try container.decode(String.self, forKey: .name)
        self.type = try container.decode(HolidayRule.HolidayType.self, forKey: .type)

        switch type {
        case .fixed:
            self.monthDay = try container.decode(String.self, forKey: .monthDay)
            self.month = nil
            self.week = nil
            self.weekDay = nil
        case .dynamic:
            self.month = try container.decode(String.self, forKey: .month)
            self.week = try container.decode(HolidayRule.Week.self, forKey: .week)
            self.weekDay = try container.decode(HolidayRule.WeekDay.self, forKey: .weekDay)
            self.monthDay = nil
        }
    }
}
