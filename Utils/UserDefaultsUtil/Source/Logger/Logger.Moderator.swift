extension Logger {
	struct Moderator {
		static func info<Value> (_ commit: Logger.Commit<Value>, _ userDefaultsItemTypeName: String, _ settings: Settings.Logging) -> Logger.Info<Value>? {
			guard settings.enable && commit.level.rawValue >= settings.level.rawValue else { return nil }
			
			let oldValue = settings.enableValuesLogging ? commit.oldValue : nil
			let newValue = settings.enableValuesLogging ? commit.newValue : nil
			
			let info = Logger.Info(
				key: commit.key,
				operation: commit.operation,
				existance: commit.existance,
				oldValue: oldValue,
				newValue: newValue,
				error: commit.error,
				userDefaultsItemTypeName: userDefaultsItemTypeName,
				level: commit.level,
				additional: commit.additional
			)
			
			return info
		}
	}
}
