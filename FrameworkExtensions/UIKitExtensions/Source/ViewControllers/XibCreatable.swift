import UIKit

protocol XibCreatable: UIViewController { }

extension XibCreatable {
	static var xibName: String { String(describing: Self.self) }
	
	static func fromXib () -> Self {
		Self.init(nibName: xibName, bundle: nil)
	}
}
