public struct Logger {
	private let userDefaultsItemTypeName: String
	
	init (_ userDefaultsItemTypeName: String) {
		self.userDefaultsItemTypeName = userDefaultsItemTypeName
	}
	
	func log<Value> (_ commit: Commit<Value>) {
		let info = Moderator.info(commit, userDefaultsItemTypeName, settings.logging)
		
		if
			let info = info,
			let loggingProvider = settings.logging.loggingProvider
		{
			loggingProvider.userDefaultsUtilLog(info)
		}
	}
}
