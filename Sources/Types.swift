import Foundation

internal enum Either<Left, Right> {
    case left(Left)
    case right(Right)
}

internal typealias Step = Either<Context, Test>
internal typealias Group = [Step]
internal typealias ResultStep = Either<String, TestResult>
internal typealias ResultGroup = [ResultStep]

internal struct SourceLocation {
    internal let file: String
    internal let line: Int
    internal let column: Int
}

public struct Test {
    internal let description: String
    internal let closure: () -> TestResult.State
    internal let location: SourceLocation
}

public class Context {
    internal let description: String
    internal let closure: (Context) -> Void
    internal var befores = [() -> Void]()
    internal var afters = [() -> Void]()


    internal init(description: String, closure: @escaping (Context) -> Void) {
        self.description = description
        self.closure = closure
    }

    public func before(_ before: @escaping () -> Void) {
        befores.append(before)
    }

    public func after(_ after: @escaping () -> Void) {
        afters.append(after)
    }

    // TODO: Get rid of the @escaping
    // The @escaping was not needed when closure was run in this method
    public func context(_ description: String, _ closure: @escaping (Context) -> Void) {
        let context = Context(description: description, closure: closure)

        Global.shared.add(context: context)
    }

    public func it(
        _ description: String,
        file: String = #file,
        line: Int = #line,
        column: Int = #column,
        _ closure: @escaping () -> TestResult.State
    ) {
        let test = Test(
            description: description,
            closure: closure,
            location: SourceLocation(file: file, line: line, column: column)
        )

        Global.shared.add(test: test)
    }
}

public struct Expression<T> {
    internal let expression: () -> T

    internal var actual: T { return expression() }

    public var to: Evaluation<T> {
        return Evaluation(map: { $0 }, actual: actual)
    }
    public var toNot: Evaluation<T> {
        return Evaluation(map: { !$0 }, actual: actual)
    }
}

public struct Evaluation<T> {
    private let map: (Bool) -> Bool
    private let actual: T

    fileprivate init(map: @escaping (Bool) -> Bool, actual: T) {
        self.map = map
        self.actual = actual
    }

    internal func evaluate(_ matcher: (_ actual: T) -> Bool) -> Bool {
        return map(matcher(actual))
    }
}

public struct TestResult {
    public enum State {
        case passed
        case failed
        case typeMismatched // TODO: include the expected and actual types if possible
        // TODO: add a mismatching values?
        case gotNil

        internal init(passed: Bool) {
            if passed {
                self = .passed
            } else {
                self = .failed
            }
        }
    }

    private let state: State
    private let description: String
    internal let location: SourceLocation

    internal init(state: State, description: String, location: SourceLocation) {
        self.state = state
        self.description = description
        self.location = location
    }

    internal var passed: Bool { return state == .passed }
    internal var failed: Bool { return state != .passed }
}

