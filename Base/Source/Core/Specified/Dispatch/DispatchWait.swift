import Foundation

public class DispatchWait {
	public let group = DispatchGroup()
	
	public func `for` (_ interval: DispatchTimeInterval) {
		group.enter()
		_ = group.wait(timeout: DispatchTime.now().advanced(by: interval))
	}
}
