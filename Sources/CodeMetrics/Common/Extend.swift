import Foundation

final class Extend<Value, Other> {
    var value: Value
    var other: Other

    init(value: Value, other: Other) {
        self.value = value
        self.other = other
    }
}
