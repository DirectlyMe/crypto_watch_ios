import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(crypto_watchTests.allTests),
    ]
}
#endif