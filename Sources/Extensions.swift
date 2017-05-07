import Foundation

extension Either: CustomDebugStringConvertible {
    var debugDescription: String {
        switch self {
        case let .left(value):
            return String(describing: value)
        case let .right(value):
            return String(describing: value)
        }
    }
}

extension Context: CustomDebugStringConvertible {
    public var debugDescription: String { return description }
}

extension Test: CustomDebugStringConvertible {
    public var debugDescription: String { return description }
}
