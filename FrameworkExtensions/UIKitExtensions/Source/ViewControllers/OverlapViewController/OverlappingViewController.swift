import UIKit



protocol OverlappingViewController where Self: UIViewController {
	func prepareForHiding (_: @escaping Completion)
}



extension OverlappingViewController {
	func prepareForHiding (_ completion: Completion) {
		completion()
	}
}
