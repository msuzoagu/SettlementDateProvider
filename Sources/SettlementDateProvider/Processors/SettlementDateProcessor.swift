// SettlementDateProcessor.swift
// Created by msuzoagu on 9/12/24.

import Foundation

protocol SettlementDateProcessor {
    func settlementDates() throws -> [Date]
}
