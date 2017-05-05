import Foundation

public func describe(_ description: String, _ closure: @escaping (Context) -> Void) {
    let context = Context(description: description)

    currentGroup = [.left(context)]

    closure(context)
}

public func expect<T>(_ expression: @autoclosure @escaping () -> T) -> Expression<T> {
    return Expression(expression: expression)
}
