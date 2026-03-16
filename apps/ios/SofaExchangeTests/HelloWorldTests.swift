import XCTest
@testable import SofaExchange

final class HelloWorldTests: XCTestCase {
    func test_returnsTrue() {
        func helloWorld() -> Bool { true }
        XCTAssertTrue(helloWorld())
    }
}
