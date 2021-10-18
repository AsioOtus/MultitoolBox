import UIKit



struct Animation {
	let duration: Double
	let options: UIView.AnimationOptions
	let animation: () -> ()
	
	init (duration: Double = 1, options: UIView.AnimationOptions = [.transitionCrossDissolve, .allowUserInteraction, .allowAnimatedContent], animation: @escaping () -> () = { }) {
		self.duration = duration
		self.options = options
		self.animation = animation
	}
}
