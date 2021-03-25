import Foundation

public class DispatchFirst {
	private(set) var isPerformed = false
	
	private let semaphore = DispatchSemaphore(value: 1)
	
	public init () { }
	
	public func perform (_ action: () -> Void) {
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
