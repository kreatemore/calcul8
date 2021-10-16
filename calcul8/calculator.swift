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
    var operations: [Operation] = []

    func performOperation(operation: SimpleMathematicalOperation) {
        if operation is Reset {
            operations.removeAll()
            clearInput()
            display(0)
            return
        }

        let displayValue = completePendingOperation(operation: operation)
        var result = displayValue ?? operations.last!.result!
        var nextOperation = Operation(a: result, operation: operation)

        if operation is SingleValueOperation {
            nextOperation.calculateResult()
            nextOperation.complete()
            result = nextOperation.result!
        }

        clearInput()
        display(result)
        operations.append(nextOperation)
        limitHistory(maxSize: HISTORY_SIZE)
    }

    private func completePendingOperation(operation: SimpleMathematicalOperation) -> Float? {
        let userInput = parseInput()
        let pendingOperationIndex = operations.firstIndex {
            $0.isPending
        }
        let pendingOperationExists = pendingOperationIndex != nil

        if !pendingOperationExists {
            return userInput
        }

        let i = pendingOperationIndex!
        let hasOperationChanged = userInput == nil // user selected + then - without entering a number

        if hasOperationChanged {
            operations[i].operation = operation
        }

        operations[i].complete(b: userInput ?? 0)
        operations[i].calculateResult()
        display(operations[i].result!)

        return operations[i].result
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
        if operations.count < maxSize {
            return
        }

        operations.removeFirst(operations.count - maxSize)
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