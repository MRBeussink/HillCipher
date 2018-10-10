import XCTest

import HillCipherTests

var tests = [XCTestCaseEntry]()
tests += HillCipherTests.allTests()
XCTMain(tests)