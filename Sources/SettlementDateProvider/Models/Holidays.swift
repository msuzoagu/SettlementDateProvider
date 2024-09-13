// Holidays.swift
// Created by msuzoagu on 9/13/24.

import Foundation

struct Holidays: Decodable {
    private(set) var rules: [HolidayRule]

    enum CodingKeys: CodingKey {
        case rules
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.rules = try container.decode([HolidayRule].self, forKey: .rules)
    }
}
