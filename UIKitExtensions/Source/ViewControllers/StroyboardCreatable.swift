import UIKit

protocol StoryboardCreatable: UIViewController { }

extension StoryboardCreatable {
	static var storyboardName: String { String(describing: Self.self) }
	static var storyboard: UIStoryboard { UIStoryboard(name: storyboardName, bundle: nil) }
	
	static func fromStoryboard () -> Self {
		storyboard.instantiateViewController(Self.self)
	}
}
