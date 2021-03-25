import XCTest
import MultitoolBase
import Foundation

class DispatchFirstTests: XCTestCase {
	func testDefaultCase () {
		let dispatchFirst = DispatchFirst()
		var counter = 0
		
		DispatchQueue.concurrentPerform(iterations: 100) { i in
			dispatchFirst.perform {
				counter += 1
			}
		}
		
		XCTAssert(counter == 1, "Unexpected counter value | Actual value – \(counter) | Expected – 1")
	}
}
