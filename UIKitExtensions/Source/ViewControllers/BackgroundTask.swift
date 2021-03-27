import UIKit



class BackgroundTask {
	private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
	
	func start () {
		backgroundTask = UIApplication.shared.beginBackgroundTask {
			self.end()
		}
	}
	
	func end () {
		UIApplication.shared.endBackgroundTask(backgroundTask)
		backgroundTask = .invalid
	}
	
	func restart () {
		if backgroundTask == .invalid {
			start()
		}
	}
}
