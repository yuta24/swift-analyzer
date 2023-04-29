import Foundation

public class Function {
    public var signature: String {
        if parameters.isEmpty {
            return name
        } else {
            return name + "(" + parameters.joined(separator: ":") + ")"
        }
    }

    internal var name: String
    internal var parameters: [String] = []

    public internal(set) var complexity: Int

    internal init(name: String, complexity: Int) {
        self.name = name
        self.complexity = complexity
    }
}
