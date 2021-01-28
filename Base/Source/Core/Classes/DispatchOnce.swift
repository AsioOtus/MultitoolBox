import Foundation

class DispatchOnce {
	private(set) var isPerformed = false
	
	let semaphore = DispatchSemaphore(value: 1)
	
	func perform (_ action: @escaping () -> Void) {
		semaphore.wait()
		
		guard !isPerformed else {
			semaphore.signal()
			return
		}
		
		isPerformed = true
		semaphore.signal()
		
		action()
	}
}
