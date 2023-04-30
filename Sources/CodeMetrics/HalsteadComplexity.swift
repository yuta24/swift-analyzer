import Foundation
import Accelerate
import SwiftSyntax
import SwiftSyntaxParser

private func calculate(operators: [String], operands: [String]) -> Float {
    let vocabulary = Float(Set(operators).count + Set(operands).count)
    let length = operators.count + operands.count

    return Float(length) * log2(vocabulary)
}

public struct HalsteadComplexity {
    internal class Volume {
        internal var operators: [String] = []
        internal var operands: [String] = []
    }

    private class Visitor: SyntaxVisitor {
        private(set) var namespace: [String] = []
        private(set) var extends: [Extend<Function, Volume>] = []

        override func visit(_ node: BinaryOperatorExprSyntax) -> SyntaxVisitorContinueKind {
            if let text = String(bytes: node.syntaxTextBytes, encoding: .utf8) {
                extends.last?.other.operators.append(text)
            }
            return .skipChildren
        }

        override func visit(_ node: IntegerLiteralExprSyntax) -> SyntaxVisitorContinueKind {
            if let text = String(bytes: node.syntaxTextBytes, encoding: .utf8) {
                extends.last?.other.operands.append(text)
            }
            return .skipChildren
        }

        override func visit(_ node: MemberAccessExprSyntax) -> SyntaxVisitorContinueKind {
            if let text = String(bytes: node.syntaxTextBytes, encoding: .utf8) {
                extends.last?.other.operands.append(text.trimmingCharacters(in: .whitespacesAndNewlines))
            }
            return .skipChildren
        }

        override func visit(_ node: StringLiteralExprSyntax) -> SyntaxVisitorContinueKind {
            if let text = String(bytes: node.syntaxTextBytes, encoding: .utf8) {
                extends.last?.other.operands.append(text)
            }
            return .skipChildren
        }

        override func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
            namespace.append(node.identifier.text)
            return .visitChildren
        }

        override func visitPost(_ node: ClassDeclSyntax) {
            namespace.removeLast()
        }

        override func visit(_ node: ActorDeclSyntax) -> SyntaxVisitorContinueKind {
            namespace.append(node.identifier.text)
            return .visitChildren
        }

        override func visitPost(_ node: ActorDeclSyntax) {
            namespace.removeLast()
        }

        override func visit(_ node: StructDeclSyntax) -> SyntaxVisitorContinueKind {
            namespace.append(node.identifier.text)
            return .visitChildren
        }

        override func visitPost(_ node: StructDeclSyntax) {
            namespace.removeLast()
        }

        override func visit(_ node: ExtensionDeclSyntax) -> SyntaxVisitorContinueKind {
            namespace.append(node.extensionKeyword.text)
            return .visitChildren
        }

        override func visitPost(_ node: ExtensionDeclSyntax) {
            namespace.removeLast()
        }

        override func visit(_ node: FunctionSignatureSyntax) -> SyntaxVisitorContinueKind {
            .skipChildren
        }

        override func visit(_ node: FunctionDeclSyntax) -> SyntaxVisitorContinueKind {
            let name: String = namespace.isEmpty ? node.identifier.text : namespace.joined(separator: ".") + "." + node.identifier.text
            extends.append(.init(value: .init(name: name, complexity: 0), other: .init()))
            return .visitChildren
        }

        override func visit(_ node: TokenSyntax) -> SyntaxVisitorContinueKind {
            guard node.parent?.is(AccessPathComponentSyntax.self) == false else {
                return .visitChildren
            }

            if node.tokenKind.isKeyword {
                if node.tokenKind != .funcKeyword {
                    extends.last?.other.operators.append(node.text)
                }
            } else {
                switch node.tokenKind {
                case .eof:
                    break
                case .leftParen:
                    extends.last?.other.operators.append("()")
                case .rightParen:
                    break
                case .leftBrace:
                    // TODO: handling
                    break
                case .rightBrace:
                    // TODO: handling
                    break
                case .leftSquareBracket:
                    // TODO: handling
                    break
                case .rightSquareBracket:
                    // TODO: handling
                    break
                case .leftAngle:
                    // TODO: handling
                    break
                case .rightAngle:
                    // TODO: handling
                    break
                case .period:
                    // TODO: handling
                    break
                case .prefixPeriod:
                    // TODO: handling
                    break
                case .comma:
                    // TODO: handling
                    break
                case .ellipsis:
                    // TODO: handling
                    break
                case .colon:
                    // TODO: handling
                    break
                case .semicolon:
                    // TODO: handling
                    break
                case .equal:
                    extends.last?.other.operators.append(node.text)
                case .atSign:
                    // TODO: handling
                    break
                case .pound:
                    // TODO: handling
                    break
                case .prefixAmpersand:
                    // TODO: handling
                    break
                case .arrow:
                    // TODO: handling
                    break
                case .backtick:
                    // TODO: handling
                    break
                case .backslash:
                    // TODO: handling
                    break
                case .exclamationMark:
                    // TODO: handling
                    break
                case .postfixQuestionMark:
                    // TODO: handling
                    break
                case .infixQuestionMark:
                    extends.last?.other.operators.append(node.text)
                case .stringQuote:
                    // TODO: handling
                    break
                case .singleQuote:
                    // TODO: handling
                    break
                case .multilineStringQuote:
                    // TODO: handling
                    break
                case .integerLiteral(let text):
                    extends.last?.other.operands.append(text)
                case .floatingLiteral(let text):
                    extends.last?.other.operands.append(text)
                case .stringLiteral(let text):
                    extends.last?.other.operands.append(text)
                case .regexLiteral(let text):
                    extends.last?.other.operands.append(text)
                case .unknown:
                    print("\(node.tokenKind)")
                    // TODO: handling
                    break
                case .identifier(let text):
                    extends.last?.other.operands.append(text)
                case .unspacedBinaryOperator:
                    extends.last?.other.operators.append(node.text)
                case .spacedBinaryOperator:
                    extends.last?.other.operators.append(node.text)
                case .postfixOperator:
                    extends.last?.other.operators.append(node.text)
                case .prefixOperator:
                    extends.last?.other.operators.append(node.text)
                case .dollarIdentifier:
                    print("\(node.tokenKind)")
                    // TODO: handling
                    break
                case .contextualKeyword:
                    break
                case .rawStringDelimiter:
                    print("\(node.tokenKind)")
                    // TODO: handling
                    break
                case .stringSegment:
                    print("\(node.tokenKind)")
                    // TODO: handling
                    break
                case .stringInterpolationAnchor:
                    // TODO: handling
                    break
                case .yield:
                    // TODO: handling
                    break
                default:
                    print("default-case: \(node.tokenKind)")
                    break
                }
            }

            switch node.tokenKind {
            case .unspacedBinaryOperator(let text):
                extends.last?.other.operators.append(text)
            case .spacedBinaryOperator(let text):
                extends.last?.other.operators.append(text)
            case .postfixOperator(let text):
                extends.last?.other.operators.append(text)
            case .prefixOperator(let text):
                extends.last?.other.operators.append(text)
            default:
                break
            }

            return .visitChildren
        }
    }

    public var functions: [Function] {
        extends.map(\.value)
    }
    public var file: Int {
        let (operators, operands): ([String], [String]) = extends.reduce(into: ([], [])) { result, extend in
            result.0 += extend.other.operators
            result.1 += extend.other.operands
        }

        let complexity = calculate(operators: operators, operands: operands)
        return complexity.isFinite ? Int(complexity) : 0
    }

    private let extends: [Extend<Function, Volume>]

    public init(contentOf url: URL) throws {
        let syntax = try SyntaxParser.parse(url)
        let visitor = Visitor(viewMode: .sourceAccurate)
        visitor.walk(syntax)

        visitor.extends
            .forEach {
                let complexity = calculate(operators: $0.other.operators, operands: $0.other.operands)
                $0.value.complexity = complexity.isFinite ? Int(complexity) : 0
            }

        self.extends = visitor.extends
    }
}
