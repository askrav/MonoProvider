import XCTest

extension PublicAPITests {
    static let __allTests = [
        ("testCurrenciesParsedProperly", testCurrenciesParsedProperly),
    ]
}

extension PersonalAPITests {
    static let __allTests = [
        ("testUserInfoParsedProperly", testUserInfoParsedProperly),
        ("testStatementParsedProperly", testStatementParsedProperly),
    ]
}


#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(PublicAPITests.__allTests),
        testCase(PersonalAPITests.__allTests),
    ]
}
#endif
