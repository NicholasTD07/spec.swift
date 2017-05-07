// Assumptions:
//   1. Only one TestResult per ResultGroup
//   2. The TestResult is always the last one in a ResultGroup
// TODO: Make the logic constrained by types

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

struct Report {
    private let groups: [ResultGroup]
    private let results: [TestResult]

    private var total: Int { return results.count }
    private var passed: Int { return results.filter { $0.state == .passed }.count }
    private var failed: Int { return results.filter { $0.state != .passed }.count }

    internal init(groups: [ResultGroup]) {
        self.groups = groups
        self.results = groups.results
    }

    func dots() {
        let dots: [String] = results.map {
            switch $0.state {
            case .passed: return "."
            default: return "F"
            }
        }

        print(dots.joined(separator: ""))
    }

    func summary() {
        print("\(total) examples, \(failed) failed, \(passed) passed.")
    }
}
