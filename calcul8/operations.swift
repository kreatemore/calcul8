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

class Reset: SimpleMathematicalOperation {
    override class var operationSign: String {
        "AC"
    }
}

class RevealResult: SimpleMathematicalOperation {
    override class var operationSign: String {
        "="
    }

    override func perform(a: Float?, b: Float?) -> Float {
        safe(a)
    }
}

class RepeatableOperation: SimpleMathematicalOperation {
}

class Reverse: RepeatableOperation {
    override class var operationSign: String {
        "±"
    }

    override func perform(a: Float?, b: Float?) -> Float {
        safe(a) * -1
    }
}

class Ratio: RepeatableOperation {
    override class var operationSign: String {
        "%"
    }

    override func perform(a: Float?, b: Float?) -> Float {
        safe(a) / 100
    }
}

struct Operation: Identifiable {
    var id = UUID()

    var a: Float?
    var b: Float?
    var operation: SimpleMathematicalOperation
    var result: Float?

    mutating func calculateResult() {
        result = operation.perform(a: a, b: b)
    }
}
