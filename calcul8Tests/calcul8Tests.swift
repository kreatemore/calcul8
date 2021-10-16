//
//  calcul8Tests.swift
//  calcul8Tests
//
//  Created by Alex Szabó on 2021. 10. 13..
//

import XCTest
@testable import calcul8

class OperatorTests: XCTestCase {
    func testMultiplication() throws {
        let result = Multiplication().perform(a: 2.5, b: 4)
        XCTAssertEqual(10, result)
    }

    func testDivision() throws {
        let result = Division().perform(a: 5, b: 2)
        XCTAssertEqual(2.5, result)
    }

    func testAddition() throws {
        let result = Addition().perform(a: 2.5, b: 2.5)
        XCTAssertEqual(5, result)
    }

    func testSubtraction() throws {
        let result = Subtraction().perform(a: 3, b: 4)
        XCTAssertEqual(-1, result)
    }
}


class CalculatorTests: XCTestCase {
    func testDisplayValueBeingEntered() throws {
        let calculator = Calculator()

        calculator.append("7")
        calculator.append("5")

        XCTAssertEqual("75", calculator.display)
    }

    func testMultipleDecimalSeparatorsAreHandled() throws {
        let calculator = Calculator()

        calculator.append("7")
        calculator.append(".")
        calculator.append("5")
        calculator.append(".")
        calculator.append("1")

        XCTAssertEqual("7.51", calculator.display)
    }

    func testOnlyDecimalSeparatorsAreHandled() throws {
        let calculator = Calculator()

        calculator.append(".")
        calculator.performOperation(operation: RevealResult())

        XCTAssertEqual("0", calculator.display)
    }

    func testPerformOperationStoresHistory() throws {
        let calculator = Calculator()

        calculator.append("1")
        calculator.performOperation(operation: Addition())
        calculator.append("1")
        calculator.performOperation(operation: RevealResult())

        XCTAssert(calculator.operations[0].operation is Addition)
        XCTAssert(calculator.operations[1].operation is RevealResult)
        XCTAssert(calculator.operations.count == 2)
    }

    func testHistoryIsLimited() throws {
        let calculator = Calculator()
        let operation: SimpleMathematicalOperation = Addition()

        for _ in 1...HISTORY_SIZE * 2 {
            calculator.append("1")
            calculator.performOperation(operation: operation)
        }

        XCTAssert(calculator.operations.count == HISTORY_SIZE)
    }

    func testPerformOperationShowsResult() throws {
        let calculator = Calculator()

        calculator.append("1")
        calculator.performOperation(operation: Addition())
        calculator.append("2")
        calculator.performOperation(operation: RevealResult())

        XCTAssertEqual("3", calculator.display)
    }

    func testSubtractNegatives() throws {
        let calculator = Calculator()

        calculator.append("1")
        calculator.performOperation(operation: Subtraction())
        calculator.append("4")
        calculator.performOperation(operation: Subtraction())
        calculator.append("4")
        calculator.performOperation(operation: Addition())
        calculator.append("5")
        calculator.performOperation(operation: RevealResult())

        XCTAssertEqual("-2", calculator.display)
    }

    func testChangeOperationMidCalculation() throws {
        let calculator = Calculator()

        calculator.append("1")
        calculator.performOperation(operation: Subtraction())
        calculator.performOperation(operation: Addition())
        calculator.append("4")
        calculator.performOperation(operation: RevealResult())

        XCTAssertEqual("5", calculator.display)
    }

    func testShowResultsKeepsLastResult() throws {
        let calculator = Calculator()

        calculator.append("1")
        calculator.performOperation(operation: Addition())
        calculator.append("2")
        calculator.performOperation(operation: RevealResult())
        calculator.performOperation(operation: RevealResult())

        XCTAssertEqual("3", calculator.display)
    }

    func testEndlesslyRepeatsOperation() throws {
        let calculator = Calculator()

        calculator.append("1")
        calculator.performOperation(operation: Reverse())
        XCTAssertEqual("-1", calculator.display)

        calculator.performOperation(operation: Reverse())
        XCTAssertEqual("1", calculator.display)

        calculator.performOperation(operation: Reverse())
        XCTAssertEqual("-1", calculator.display)
    }
}