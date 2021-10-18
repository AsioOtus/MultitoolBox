import UIKit



class TypifyOverlapViewController<OverlappingVC: OverlappingViewController>: OverlapViewController {	
	var typifyOverlappingVC: OverlappingVC? {
		get { overlappingVC as? OverlappingVC }
		set { overlappingVC = newValue }
	}
}
