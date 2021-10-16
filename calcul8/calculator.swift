//
// Created by Alex Szabó on 2021. 10. 14..
//

import Foundation

let HISTORY_SIZE = 5
let DISPLAY_EMPTY = ""
let DISPLAY_ZERO = "0"
let DECIMAL_SEPARATOR = "."
let THOUSANDS_SEPARATOR = " "

class Calculator: ObservableObject {
    @Published var result: Float? = nil
    @Published var pending = String(DISPLAY_EMPTY)
    @Published var display = String(DISPLAY_ZERO)
    var operationsToPerform: [Operation] = []

    func performOperation(operation: SimpleMathematicsOperation) {
        if operation is Reset {
            operationsToPerform.removeAll()
            clearInput()
            display(0)
            return
        }

        let currentNumber = completeMostRecentPendingOperation(operation: operation)

        if operation is RevealResult {
            return
        }

        var result = currentNumber ?? operationsToPerform.last!.result!
        var nextOperation = Operation(a: result, operation: operation)
        let isOperationRepeatable = operation is Reverse || operation is Ratio

        if isOperationRepeatable {
            let operationResult = operation.perform(a: nextOperation.a, b: nextOperation.b)
            nextOperation.b = 0
            nextOperation.result = operationResult
            result = operationResult
        }

        clearInput()
        display(result)
        operationsToPerform.append(nextOperation)
        limitHistory(maxSize: HISTORY_SIZE)
    }

    private func completeMostRecentPendingOperation(operation: SimpleMathematicsOperation) -> Float? {
        let userInput = parseInput()
        let mostRecentPendingOperationIndex = operationsToPerform.firstIndex {
            $0.b == nil
        }
        let areNoPendingOperations = mostRecentPendingOperationIndex == nil

        if areNoPendingOperations {
            return userInput
        }

        let hasOperationChanged = userInput == nil // user selected + then - without entering a number
        let i = mostRecentPendingOperationIndex!

        if hasOperationChanged {
            operationsToPerform[i].operation = operation
        }

        operationsToPerform[i].b = userInput
        operationsToPerform[i].calculateResult()
        display(operationsToPerform[i].result!)

        return operationsToPerform[i].result
    }

    private func parseInput() -> Float? {
        if (pending == DECIMAL_SEPARATOR) {
            return Float(0)
        }

        return Float(pending)
    }

    private func clearInput() {
        pending = String(DISPLAY_EMPTY)
    }

    private func limitHistory(maxSize: Int) {
        if operationsToPerform.count < maxSize {
            return
        }

        operationsToPerform.removeFirst(operationsToPerform.count - maxSize)
    }

    func append(_ numericChar: String) {
        let isZeroPrefix = pending == DISPLAY_EMPTY && numericChar == DISPLAY_ZERO
        let isDuplicateDecimalSeparator = pending.contains(DECIMAL_SEPARATOR) && numericChar == DECIMAL_SEPARATOR

        if isZeroPrefix || isDuplicateDecimalSeparator {
            return
        }

        pending = pending + numericChar
        display(parseInput()!)
    }

    private func display(_ number: Float) {
        let result = NSNumber(value: number)
        let formatter = NumberFormatter()
        formatter.groupingSeparator = THOUSANDS_SEPARATOR
        formatter.numberStyle = NumberFormatter.Style.decimal

        self.result = Float(truncating: result)
        display = formatter.string(from: result)!
    }
}