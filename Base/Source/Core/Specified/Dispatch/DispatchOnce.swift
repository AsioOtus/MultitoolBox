import Foundation

public class DispatchOnce {
	private let dispatchFirst = DispatchFirst()
	
	private let action: () -> Void
	
	public init (_ action: @escaping () -> Void) {
		self.action = action
	}
	
	public func perform () {
		dispatchFirst.perform(action)
	}
}
