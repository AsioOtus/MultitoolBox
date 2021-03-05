import Foundation

extension DispatchQueue {
	func delay (seconds: Double, block: @escaping () -> ()) {
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds, execute: block)
	}
}
