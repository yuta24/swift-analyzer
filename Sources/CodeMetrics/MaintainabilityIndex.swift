import Foundation

public struct MaintainabilityIndex {
    public var value: Float {
        let value = 171.0 - 5.2 * log(Float(halsteadComplexity.file)) - 0.23 * (Float(cyclomaticComplexity.file)) - 16.2 * log(Float(lineOfCode.code))
        return max(0, value)
    }

    private let lineOfCode: LineOfCode
    private let cyclomaticComplexity: CyclomaticComplexity
    private let halsteadComplexity: HalsteadComplexity

    public init(contentOf url: URL) throws {
        self.lineOfCode = try LineOfCode(contentOf: url)
        self.cyclomaticComplexity = try CyclomaticComplexity(contentOf: url)
        self.halsteadComplexity = try HalsteadComplexity(contentOf: url)
    }
}
