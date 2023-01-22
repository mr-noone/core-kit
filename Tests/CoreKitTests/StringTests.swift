import XCTest
import CoreKit

final class StringTests: XCTestCase {
    func testFileExtension() {
        XCTAssertEqual("test.sss".fileExtension, "sss")
        XCTAssertEqual("test.sss.aaa".fileExtension, "aaa")
        XCTAssertEqual(".test".fileExtension, "")
        XCTAssertEqual("test".fileExtension, "")
    }
    
    func testFilename() {
        XCTAssertEqual("test".filename, "test")
        XCTAssertEqual("test.sss".filename, "test")
        XCTAssertEqual("test.sss.aaa".filename, "test.sss")
        XCTAssertEqual(".test".filename, ".test")
        XCTAssertEqual("".filename, "")
    }
}
