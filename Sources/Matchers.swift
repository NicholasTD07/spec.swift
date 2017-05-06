import Foundation

extension Expression where T: Collection {
    public func beEmpty() -> TestResult.State {
        return .init(passed: evaluate(actual.isEmpty))
    }
}

extension Expression where T: Sequence, T.Iterator.Element: Equatable {
    public func contain(_ value: T.Iterator.Element) -> TestResult.State {
        return .init(passed: evaluate(actual.contains(value)))
    }
}

public func == <T>(_ expression: Expression<T>, _ expected: T) -> TestResult.State
    where T: Equatable
{
    return .init(passed: expression.evaluate(expression.actual == expected))
}

public func != <T>(_ expression: Expression<T>, _ expected: T) -> TestResult.State
    where T: Equatable
{
    return .init(passed: expression.evaluate(expression.actual != expected))
}

public func == <T>(_ expression: Expression<Optional<T>>, _ expected: T) -> TestResult.State
    where T: Equatable
{
    guard let actual = expression.actual else {
        return .typeMismatched
    }

    return .init(passed: expression.evaluate(actual == expected))
}

public func != <T>(_ expression: Expression<Optional<T>>, _ expected: T) -> TestResult.State
    where T: Equatable
{
    guard let actual = expression.actual else {
        return .typeMismatched
    }

    return .init(passed: expression.evaluate(actual != expected))
}
