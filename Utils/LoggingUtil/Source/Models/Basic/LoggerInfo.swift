public struct LoggerInfo {
	public var level: LoggingLevel
	public var source: [String]
	
	init (
		level: LoggingLevel = .info,
		source: [String] = []
	) {
		self.level = level
		self.source = source
	}
}
