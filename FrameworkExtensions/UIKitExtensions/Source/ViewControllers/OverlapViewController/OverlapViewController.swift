import UIKit



class OverlapViewController: UIViewController {
	private(set) var _minOverlapSeconds: Double = 0
	var minOverlapSeconds: Double? {
		get { _minOverlapSeconds }
		set { _minOverlapSeconds = newValue ?? 0 }
	}
	
	var overlapDisplayAnimation = Animation(duration: 0.5)
	var overlapHideAnimation = Animation(duration: 0.5)
	
	weak var overlappedVC: OverlappedViewController? {
		willSet {
			guard let overlappedVC = overlappedVC else { return }
			
			DispatchQueue.main.async {
				overlappedVC.willMove(toParent: nil)
				overlappedVC.view.removeFromSuperview()
				overlappedVC.removeFromParent()
			}
			
			overlappedVC.overlapVC = nil
		}
		didSet {
			guard let overlappedVC = overlappedVC else { return }
			
			self.insertFullframeChild(overlappedVC, index: 0)
			
			overlappedVC.overlapVC = self
		}
	}
	
	var overlappingVC: OverlappingViewController?
	
	var isOverlapping: Bool {
		guard let overlappingVC = overlappingVC else { return false }
		return children.contains(overlappingVC)
	}
}



extension OverlapViewController {
	static func create (
		overlappedVC: OverlappedViewController? = nil,
		overlappingVC: OverlappingViewController? = nil,
		minOverlapSeconds: Double? = nil,
		animation: Animation = .init(duration: 0.5)
	) -> Self {
		let overlapVC = Self()
		
		overlapVC.overlappedVC = overlappedVC
		overlapVC.overlappingVC = overlappingVC
		
		overlapVC.minOverlapSeconds = minOverlapSeconds
		
		overlapVC.overlapDisplayAnimation = animation
		overlapVC.overlapHideAnimation = animation
		
		return overlapVC
	}
}



extension OverlapViewController {
	func displayOverlap (_ completion: Completion? = nil) {
		guard let overlapVC = overlappingVC else { return }
		
		DispatchQueue.main.async {
			self.addChild(overlapVC)
			self.view.addSubview(overlapVC.view)
			overlapVC.view.pinToBounds(self.view)
			
			UIView.transition(
				with: self.view,
				duration: self.overlapDisplayAnimation.duration,
				options: self.overlapDisplayAnimation.options,
				animations: self.overlapDisplayAnimation.animation,
				completion: { _ in
					overlapVC.didMove(toParent: self)
					completion?()
				}
			)
		}
	}
	
	func hideOverlap (_ completion: Completion? = nil) {
		guard let overlappingVC = overlappingVC else { return }
		
		DispatchQueue.main.asyncAfter(deadline: .now() + _minOverlapSeconds) {
			overlappingVC.prepareForHiding { [weak overlappingVC, weak self] in
				guard let self = self else { return }
				
				UIView.transition(
					with: self.view,
					duration: self.overlapHideAnimation.duration,
					options: self.overlapHideAnimation.options,
					animations: {
						overlappingVC?.willMove(toParent: nil)
						
						self.overlapHideAnimation.animation()
						
						overlappingVC?.view.removeFromSuperview()
						overlappingVC?.removeFromParent()
					},
					completion: { _ in
						completion?()
					}
				)
			}
		}
	}
}



extension OverlapViewController {
	func action (_ action: @escaping (@escaping Completion) -> Void, _ completion: Completion? = nil) {
		displayOverlap {
			action {
				self.hideOverlap(completion)
			}
		}
	}
	
	func actionImmediately (_ action: @escaping (Completion) -> Void, _ completion: Completion? = nil) {
		displayOverlap()
		action {
			self.hideOverlap(completion)
		}
	}
	
	func replaceOverlapped (_ vc: OverlappedViewController, _ completion: Completion? = nil) {
		displayOverlap {
			self.overlappedVC = vc
			self.hideOverlap(completion)
		}
	}
}
