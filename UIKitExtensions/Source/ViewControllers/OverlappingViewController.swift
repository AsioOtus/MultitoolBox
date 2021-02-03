import UIKit



extension UIView {
	func pinToBounds (_ view: UIView) {
		view.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			view.topAnchor.constraint(equalTo: topAnchor),
			view.bottomAnchor.constraint(equalTo: bottomAnchor),
			view.leadingAnchor.constraint(equalTo: leadingAnchor),
			view.trailingAnchor.constraint(equalTo: trailingAnchor)
		])
	}
}



extension OverlappingViewController {
	struct Animation {
		let duration: Double
		let options: UIView.AnimationOptions
		let animation: () -> ()
		
		init (duration: Double = 1, options: UIView.AnimationOptions = .transitionCrossDissolve, animation: @escaping () -> () = { }) {
			self.duration = duration
			self.options = options
			self.animation = animation
		}
	}
}



class OverlappingViewController: UIViewController {
	typealias Completion = () -> ()
	
	private var _minOverlapSeconds: Double = 0
	var minOverlapSeconds: Double? {
		get { _minOverlapSeconds }
		set { _minOverlapSeconds = newValue ?? 0 }
	}
	
	var overlapDisplayAnimation = Animation()
	var overlapHideAnimation = Animation()
	
	var mainViewController: UIViewController? {
		willSet {
			guard let mainVC = mainViewController else { return }
			
			mainVC.willMove(toParent: nil)
			mainVC.view.removeFromSuperview()
			mainVC.removeFromParent()
		}
		didSet {
			guard let mainVC = mainViewController else { return }
			
			addChild(mainVC)
			view.insertSubview(mainVC.view, at: 0)
			view.pinToBounds(mainVC.view)
			mainVC.didMove(toParent: self)
		}
	}
	
	var overlapViewController: UIViewController?
}



extension OverlappingViewController {
	static func create (mainViewController: UIViewController? = nil, overlapViewController: UIViewController? = nil, minOverlapSeconds: Double? = nil, animation: Animation = Animation()) -> OverlappingViewController {
		let overlapVC = Self()
		
		overlapVC.mainViewController = mainViewController
		overlapVC.overlapViewController = overlapViewController
		
		overlapVC.minOverlapSeconds = minOverlapSeconds
		
		overlapVC.overlapDisplayAnimation = animation
		overlapVC.overlapHideAnimation = animation
		
		return overlapVC
	}
}



extension OverlappingViewController {
	func displayOverlap (_ completion: Completion? = nil) {
		guard let overlapVC = overlapViewController else { return }
		
		addChild(overlapVC)
		view.addSubview(overlapVC.view)
		view.pinToBounds(overlapVC.view)
		
		UIView.transition(
			with: view,
			duration: overlapDisplayAnimation.duration,
			options: overlapDisplayAnimation.options,
			animations: overlapDisplayAnimation.animation,
			completion: { _ in
				overlapVC.didMove(toParent: self)
				completion?()
			}
		)
	}
	
	func hideOverlap (_ completion: Completion? = nil) {
		guard let overlapVC = overlapViewController else { return }
		
		DispatchQueue.main.asyncAfter(deadline: .now() + _minOverlapSeconds) {
			UIView.transition(
				with: self.view,
				duration: self.overlapHideAnimation.duration,
				options: self.overlapHideAnimation.options,
				animations: {
					overlapVC.willMove(toParent: nil)
					overlapVC.view.removeFromSuperview()
					overlapVC.removeFromParent()
					
					self.overlapHideAnimation.animation()
				},
				completion: { _ in
					completion?()
				}
			)
		}
	}
}



extension OverlappingViewController {
	func action (action: @escaping (@escaping Completion) -> (), completion: Completion? = nil) {
		displayOverlap {
			action {
				self.hideOverlap(completion)
			}
		}
	}
	
	func actionImmediately (action: @escaping (Completion) -> (), completion: Completion? = nil) {
		displayOverlap()
		action {
			self.hideOverlap(completion)
		}
	}
	
	func replaceMain (_ vc: UIViewController, _ completion: Completion? = nil) {
		displayOverlap {
			self.mainViewController = vc
			self.hideOverlap(completion)
		}
	}
}
