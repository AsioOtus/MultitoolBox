import Foundation

class DispatchSingle {
	private(set) var isFree = true
	
	let semaphore = DispatchSemaphore(value: 1)
	
	func perform (_ action: @escaping () -> Void) {
		semaphore.wait()
		
		guard isFree else {
			semaphore.signal()
			return
		}
		
		isFree = false
		semaphore.signal()
		
		action()
		
		isFree = true
	}
	
	func perform (_ action: @escaping (_ completion: @escaping () -> Void) -> Void) {
		semaphore.wait()
		
		guard isFree else {
			semaphore.signal()
			return
		}
		
		isFree = false
		semaphore.signal()
		
		action {
			self.isFree = true
		}
	}
}
