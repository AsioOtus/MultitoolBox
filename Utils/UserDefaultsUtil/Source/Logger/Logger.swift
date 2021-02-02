public struct Logger {
	let moderator: Moderator
	let settings: Settings.Logging
	
	init (_ userDefaultsItemTypeName: String, _ settings: Settings.Logging) {
		self.settings = settings
		self.moderator = Logger.Moderator(userDefaultsItemTypeName: userDefaultsItemTypeName, settings: settings)
	}
	
	func log<Value> (_ commit: Commit<Value>) {
		let info = moderator.info(commit)
		
		if
			let info = info,
			let loggingProvider = settings.loggingProvider
		{
			loggingProvider.userDefaultsUtilLog(info)
		}
	}
}
