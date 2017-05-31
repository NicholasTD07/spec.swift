import func XCTest.XCTFail
import class XCTest.XCTestCase

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

// HACK
#if _runtime(_ObjC)
private class ReportingTestCase: XCTestCase { }
private let globalReportingTestCase = ReportingTestCase()
#endif

internal struct Report {
    internal enum Style {
        case dot
        case xctest
    }

    private let groups: [ResultGroup]
    private let results: [TestResult]

    private var total: Int { return results.count }
    private var passed: Int { return results.filter { $0.passed }.count }
    private var failed: Int { return results.filter { $0.failed }.count }

    internal init(groups: [ResultGroup]) {
        self.groups = groups
        self.results = groups.results
    }

    internal func report(styles: [Style]) {
        styles.forEach { style in
            switch style {
            case .dot: dots()
            case .xctest: xctest()
            }
        }

        failures()

        summary()
    }

    private func dots() {
        let dots: [String] = results.map { $0.passed }.map { $0 ? "." : "F" }

        print(dots.joined(separator: ""))
    }

    private func xctest() {
        let results = groups.results.filter { $0.failed }
        let locations = results.map { $0.location }

        locations.forEach {
            #if !_runtime(_ObjC)
                XCTFail("Test failed", file: $0.file, line: $0.line)
            #else
                globalReportingTestCase.recordFailure(withDescription: "Test failed", inFile: $0.file, atLine: $0.line, expected: true)
            #endif
        }
    }

    private func failures() {
        let results = groups.results.filter { $0.failed }
        let locations = results.map { $0.location }

        locations.forEach {
            print("\($0.file):\($0.line):\($0.column): error: test failed ")
        }
    }

    private func summary() {
        print("\(total) examples, \(failed) failed, \(passed) passed.")
    }
}
