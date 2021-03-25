import Foundation

public class DispatchWait {
	private init () { }
	
	public static func `for` (_ interval: DispatchTimeInterval) {
		let group = DispatchGroup()
		group.enter()
		_ = group.wait(timeout: DispatchTime.now().advanced(by: interval))
	}
}
