//
// Created by Alex Szabó on 2021. 10. 17..
//

import Foundation

class SimpleMathematicsOperation {
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

class Multiplication: SimpleMathematicsOperation {
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

class Division: SimpleMathematicsOperation {
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

class Addition: SimpleMathematicsOperation {
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

class Subtraction: SimpleMathematicsOperation {
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

class Reverse: SimpleMathematicsOperation {
    override class var operationSign: String {
        "±"
    }

    override func perform(a: Float?, b: Float?) -> Float {
        if a == nil {
            return safe(b) * -1
        } else {
            return safe(a) * -1
        }
    }
}

class Ratio: SimpleMathematicsOperation {
    override class var operationSign: String {
        "%"
    }

    override func perform(a: Float?, b: Float?) -> Float {
        if a == nil {
            return safe(b) / 100
        } else {
            return safe(a) / 100
        }
    }
}

class Reset: SimpleMathematicsOperation {
    override class var operationSign: String {
        "AC"
    }
}

class RevealResult: SimpleMathematicsOperation {
    override class var operationSign: String {
        "="
    }

    override func perform(a: Float?, b: Float?) -> Float {
        safe(a)
    }
}

struct Operation: Identifiable {
    var id = UUID()

    var a: Float?
    var b: Float?
    var operation: SimpleMathematicsOperation
    var result: Float?

    mutating func calculateResult() {
        result = operation.perform(a: a, b: b)
    }
}
