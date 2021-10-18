//
// Created by Alex Szabó on 2021. 10. 14..
//

import Foundation

let DISPLAY_EMPTY = ""
let DISPLAY_ZERO = "0"
let DECIMAL_SEPARATOR = "."
let THOUSANDS_SEPARATOR = " "

class Calculator: ObservableObject {
    @Published var result: Float? = nil
    @Published var input = String(DISPLAY_EMPTY)
    @Published var display = String(DISPLAY_ZERO)

    private var calculations: CalculationRepository

    init(calculationRepository: CalculationRepository) {
        calculations = calculationRepository
    }

    func append(_ numericChar: String) {
        let isZeroPrefix = input == DISPLAY_EMPTY && numericChar == DISPLAY_ZERO
        let isDuplicateDecimalSeparator = input.contains(DECIMAL_SEPARATOR) && numericChar == DECIMAL_SEPARATOR

        if isZeroPrefix || isDuplicateDecimalSeparator {
            return
        }

        input = input + numericChar
        display(parseInput()!)
    }

    func performOperation(operation: SimpleMathematicalOperation) {
        let displayValue = completePendingCalculation(operation: operation)
        var result = displayValue ?? calculations.last!.result!
        let calculation = Calculation(a: result, operation: operation)
        calculations.add(calculation)

        if operation is SingleValueOperation {
            result = calculations.completePending()!
        }

        clearInput()
        display(result)
    }

    private func completePendingCalculation(operation: SimpleMathematicalOperation) -> Float? {
        let userInput = parseInput()
        let pendingOperation = calculations.getPending()

        if pendingOperation == nil {
            return userInput
        }

        let hasOperationChanged = userInput == nil // e.g. user selected + then - without entering a number
        let updatedOperation = hasOperationChanged ? operation : nil

        return calculations.completePending(missingValue: userInput ?? 0, operation: updatedOperation)
    }

    private func parseInput() -> Float? {
        if (input == DECIMAL_SEPARATOR) {
            return Float(0)
        }

        return Float(input)
    }

    private func clearInput() {
        input = String(DISPLAY_EMPTY)
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