import UIKit



protocol TypifyView: UIViewController {
	associatedtype RootView: UIView
}



extension TypifyView {
	var rootView: RootView { view as! RootView }
}
