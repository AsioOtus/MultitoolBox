public struct LoggerInfo {
	public var level: LoggingLevel
	public var source: [String]
	
	public init (
		level: LoggingLevel = .info,
		source: [String] = []
	) {
		self.level = level
		self.source = source
	}
}
