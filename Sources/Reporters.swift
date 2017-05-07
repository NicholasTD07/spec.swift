// Assumptions:
//   1. Only one TestResult per ResultGroup
//   2. The TestResult is always the last one in a ResultGroup
// TODO: Make it type-safe

private extension Array where Element == ResultGroup {
    var results: [TestResult] {
        return map { group -> [TestResult] in
            return group.flatMap { step -> TestResult? in
                switch step {
                case .left: return nil
                case let .right(testResult): return testResult
                }
            }
        }.flatMap { $0 }
    }

    var failed: [ResultGroup] {
        return filter { group in
            guard let last = group.last else { return false }
            guard case .left = last else { return false }

            return true
        }
    }
}

enum Reporter {
    private struct Report {
        private let groups: [ResultGroup]

        internal init(groups: [ResultGroup]) {
            self.groups = groups
        }
    }
}

enum DotReporter {

    private struct Report {
        fileprivate let dots: [Dot]
        fileprivate let total: Int
        fileprivate let passed: Int
        fileprivate let failed: Int
        fileprivate let failedGroups: [ResultGroup]

        static func from(resultGroups groups: [ResultGroup]) -> Report {
            let results = groups.results

            let dots: [Dot] = results.map {
                switch $0.state {
                    case .passed: return .passed
                    default: return .failed
                }
            }

            return Report(
                dots: dots,
                total: results.count,
                passed: results.filter { $0.state == .passed }.count,
                failed: results.filter { $0.state != .passed }.count,
                failedGroups: groups.failed
            )
        }
    }

    private enum Dot {
        case passed
        case failed

        var string: String {
            switch self {
            case .passed: return "."
            case .failed: return "F"
            }
        }
    }

    internal static func report(resultGroups groups: [ResultGroup]) {
        let results = groups.results

        let dotsString = Report.from(resultGroups: groups).dots.map { $0.string }.joined(separator: "")

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
