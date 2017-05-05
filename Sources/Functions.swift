import Foundation

public func describe(_ name: String, _ closure: @escaping (Context) -> Void) {
    let context = Context(name: name)

    currentGroup = [.left(context)]

    closure(context)
}

public func expect<T>(_ expression: @autoclosure @escaping () -> T) -> Expression<T> {
    return Expression(expression: expression)
}
