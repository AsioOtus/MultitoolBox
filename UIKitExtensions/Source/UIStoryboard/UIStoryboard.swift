import UIKit


extension UIStoryboard {
	static let main = UIStoryboard(name: "Main", bundle: nil)
}



extension UIStoryboard {
	func instantiateViewController <T: UIViewController> (_ type: T.Type) -> T {
		instantiateViewController(withIdentifier: String(describing: type.self)) as! T
	}
	
	subscript <T: UIViewController> (_ type: T.Type) -> T {
		instantiateViewController(type)
	}
}
