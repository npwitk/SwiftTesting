//
//  State.swift
//  OnlineStoreMV
//
//  Created by Nonprawich I. on 8/12/25.
//

import Foundation

class StateTest {
    private static var numbers = [1, 2, 3]
    
    func addNumber(_ number: Int) {
        StateTest.numbers.append(number)
    }
    
    func addNumber(_ number: [Int]) {
        StateTest.numbers.append(contentsOf: number)
    }
    
    func removeLastNumber() -> Int? {
        StateTest.numbers.popLast()
    }
    
    var count: Int {
        return StateTest.numbers.count
    }
}
