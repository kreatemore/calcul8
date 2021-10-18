//
// Created by Alex Szabó on 2021. 10. 17..
//

import Foundation

class SimpleMathematicalOperation {
    var safeDefault: Float {
        Float(1)
    }

    class var operationSign: String {
        ""
    }

    required init() {}

    func perform(a: Float?, b: Float?) -> Float {
        Float()
    }

    func asString(a: Float, b: Float, result: Float) -> String {
        String(a) + type(of: self).operationSign + String(b) + "=" + String(result)
    }

    internal func safe(_ floatOrNil: Float?) -> Float {
        floatOrNil ?? safeDefault
    }
}

class Multiplication: SimpleMathematicalOperation {
    override class var operationSign: String {
        "×"
    }

    override var safeDefault: Float {
        Float(1)
    }

    override func perform(a: Float?, b: Float?) -> Float {
        safe(a) * safe(b)
    }
}

class Division: SimpleMathematicalOperation {
    override class var operationSign: String {
        "÷"
    }

    override var safeDefault: Float {
        Float(1)
    }

    override func perform(a: Float?, b: Float?) -> Float {
        if a == nil {
            return b!
        }

        return safe(a) / safe(b)
    }
}

class Addition: SimpleMathematicalOperation {
    override class var operationSign: String {
        "+"
    }

    override var safeDefault: Float {
        Float(0)
    }

    override func perform(a: Float?, b: Float?) -> Float {
        safe(a) + safe(b)
    }
}

class Subtraction: SimpleMathematicalOperation {
    override class var operationSign: String {
        "-"
    }

    override var safeDefault: Float {
        Float(0)
    }

    override func perform(a: Float?, b: Float?) -> Float {
        safe(a) - safe(b)
    }
}

class SingleValueOperation: SimpleMathematicalOperation {
}

class Reset: SingleValueOperation {
    override class var operationSign: String {
        "AC"
    }

    override func perform(a: Float?, b: Float?) -> Float {
        Float(0)
    }
}

class RevealResult: SingleValueOperation {
    override class var operationSign: String {
        "="
    }

    override func perform(a: Float?, b: Float?) -> Float {
        safe(a)
    }
}

class Reverse: SingleValueOperation {
    override class var operationSign: String {
        "±"
    }

    override func perform(a: Float?, b: Float?) -> Float {
        safe(a) * -1
    }
}

class Ratio: SingleValueOperation {
    override class var operationSign: String {
        "%"
    }

    override func perform(a: Float?, b: Float?) -> Float {
        safe(a) / 100
    }
}

struct Calculation: Identifiable {
    var id = UUID()
    var a: Float
    var b: Float?
    var operation: SimpleMathematicalOperation
    var result: Float?
    var isPending: Bool {
        get {
            b == nil
        }
    }

    mutating func calculateResult() {
        result = operation.perform(a: a, b: b)
    }

    mutating func complete(b: Float = 0) {
        self.b = b
    }
}

let HISTORY_SIZE = 3

class CalculationRepository {
    var calculations: [Calculation] = []
    var last: Calculation? {
        get {
            calculations.last
        }
    }

    private var pendingIndex: Int? = nil

    func add(_ calculation: Calculation) {
        calculations.append(calculation)
        manageCalculationsSize()

        if calculation.isPending {
            pendingIndex = calculations.count - 1
        }
    }

    func getPending() -> Calculation? {
        guard pendingIndex == nil else {
            return calculations[pendingIndex!]
        }

        return nil
    }

    func completePending(missingValue: Float = 0, operation: SimpleMathematicalOperation? = nil) -> Float? {
        guard pendingIndex == nil else {
            if operation != nil {
                calculations[pendingIndex!].operation = operation!
            }

            calculations[pendingIndex!].complete(b: missingValue)
            calculations[pendingIndex!].calculateResult()
            let result = calculations[pendingIndex!].result
            pendingIndex = nil

            return result
        }

        return nil
    }

    private func manageCalculationsSize() {
        if calculations.count <= HISTORY_SIZE {
            return
        }

        calculations.removeFirst(calculations.count - HISTORY_SIZE)
    }
}