import UIKit



protocol OverlappedViewController where Self: UIViewController {
	var overlapVC: OverlapViewController? { get set }
}
