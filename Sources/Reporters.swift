enum DotReporter {

    enum Dot {
        case passed
        case failed

        var string: String {
            switch self {
            case .passed: return "."
            case .failed: return "F"
            }
        }
    }
    static func report(resultGroups groups: [ResultGroup]) {
        let results = groups.map { group -> [TestResult] in
            return group.flatMap {
                switch $0 {
                case .left: return nil
                case let .right(testResult): return testResult
                }
            }
        }.joined()

        let dots: [Dot] = results.map {
            switch $0.state {
                case .passed: return .passed
                default: return .failed
            }
        }

        let dotsString = dots.map { $0.string }.joined(separator: "")

        print(dotsString)

        summary(results: Array(results))
    }
}

private func summary(results: [TestResult]) {
    let total = results.count
    let passed = results.filter { $0.state == .passed }.count
    let failed = results.filter { $0.state != .passed }.count

    print("\(total) examples, \(failed) failed, \(passed) passed.")
}

/* private func _(results: [TestResult]) { */
/*     print("\(file):\(line):\(column) expected to \(expectation), got \(actual)") */
/* } */
