//
//  ConversionModel.swift
//  NumberConverter
//
//  Created by Bobby Bagley on 6/20/25.
//

import Foundation

// Trying enum instead of class because I forgot how to use an enum in the exam. Should be appropriate here.
enum NumberBase: Int {
    case binary = 2
    case octal = 8
    case decimal = 10
    case hexadecimal = 16
}

// CORE LOGIC for my program.
struct ConversionModel {

    // Converts string representation of the number into an integer.
    func stringToInt(fromString: String, base: NumberBase) -> Int? {
        return Int(fromString, radix: base.rawValue)
    }

    // Converts integer into a string representation of the number.
    func intToString(fromInt: Int, base: NumberBase) -> String {
        return String(fromInt, radix: base.rawValue, uppercase: true)
    }
    
    // Shifts the bits of an integer one position to the left.
    func shiftLeft(value: Int) -> Int {
        return value << 1
    }
    
    // Shifts the bits of an integer one position to the right.
    func shiftRight(value: Int) -> Int {
        return value >> 1
    }

    // Applies a bitwise AND mask to an integer. Comeback, not sure if I got it right.
    func applyMask(value: Int, mask: Int) -> Int {
        return value & mask
    }
}
