//
//  MessageStatus.swift
//  Cortex
//
//  Created by Hadi Ahmad on 8/31/25.
//


enum MessageStatus: Int {
    case pending = 0
    case sending = 1
    case delivered = 2
    case received = 3
    case failed = 4

    func toInt16() -> Int16 {
        return Int16(self.rawValue)
    }

    init(from int16Value: Int16) {
        self = MessageStatus(rawValue: Int(int16Value)) ?? .pending
    }
}
