import Foundation

internal enum Either<Left, Right> {
    case left(Left)
    case right(Right)
}

internal typealias Step = Either<Context, Test>
internal typealias Group = [Step]
internal typealias ResultStep = Either<String, TestResult>
internal typealias ResultGroup = [ResultStep]

public struct Test {
    internal let description: String
    internal let closure: () -> TestResult.State
}

public class Context {
    internal let description: String
    internal var befores = [() -> Void]()
    internal var afters = [() -> Void]()


    internal init(description: String) {
        self.description = description
    }

    public func before(_ before: @escaping () -> Void) {
        befores.append(before)
    }

    public func after(_ after: @escaping () -> Void) {
        afters.append(after)
    }

    public func context(_ description: String, _ closure: (Context) -> Void) {
        guard !currentGroup.isEmpty else {
            // Only publicly accessible way to create `Context`
            // is to call the global `describe` func
            // and that adds the created context to currentGroup
            fatalError("Impossible Error...")
        }

        let context = Context(description: description)

        currentGroup.append(.left(context))

        closure(context)

        _ = currentGroup.popLast()
    }

    public func it(_ description: String, _ closure: @escaping () -> TestResult.State) {
        guard !currentGroup.isEmpty else {
            // Only publicly accessible way to create `Context`
            // is to call the global `describe` func
            // and that adds the created context to currentGroup
            fatalError("Impossible Error...")
        }

        var group = currentGroup
        let test = Test(description: description, closure: closure)

        group.append(.right(test))

        groups.append(group)
    }
}

public struct Expression<T> {
    internal let expression: () -> T
    /* interna let location: */

    internal var actual: T { return expression() }

    public var to: Expression { return self }
}

public struct TestResult {
    internal let description: String
    internal let state: State

    public enum State {
        case passed
        case failed
        case typeMismatched // TODO: include the expected and actual types if possible
        // TODO: add a mismatching values?

        internal init(passed: Bool) {
            if passed {
                self = .passed
            } else {
                self = .failed
            }
        }
    }
}

