import XCTest
@testable import SimpleGrapher

class SimpleGrapherTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(SimpleGrapher().text, "Hello, World!")
    }


    static var allTests : [(String, (SimpleGrapherTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
