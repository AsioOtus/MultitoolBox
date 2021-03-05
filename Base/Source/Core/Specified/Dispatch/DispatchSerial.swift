import Foundation

class DispatchSerial {
	let semaphore = DispatchSemaphore(value: 1)
	
	func perform (_ action: () -> Void) {
		semaphore.wait()
		
		action()
		
		semaphore.signal()
	}
	
	func perform (_ action: (_ completion: @escaping () -> Void) -> Void) {
		semaphore.wait()
		
		action {
			self.semaphore.signal()
		}
	}
}
