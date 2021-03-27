import UIKit

extension UIViewController {
	func insertFullframeChild (
		_ childVC: UIViewController,
		_ view: UIView? = nil,
		index: Int = 0
	) {
		DispatchQueue.main.async {
			let containerView: UIView = view ?? self.view
			
			self.addChild(childVC)
			containerView.insertSubview(childVC.view, at: index)
			childVC.view.pinToBounds(containerView)
			childVC.didMove(toParent: self)
		}
	}
}
