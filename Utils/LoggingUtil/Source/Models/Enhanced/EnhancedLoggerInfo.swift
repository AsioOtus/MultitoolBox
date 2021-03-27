public struct EnhancedLoggerInfo {
	public var level: LoggingLevel
	public var source: [String]
	public var tags: Set<String>
	public var details: [String: Any]
	public var comment: String
	
	public init (
		level: LoggingLevel = .info,
		source: [String] = [],
		tags: Set<String> = [],
		details: [String : Any] = [:],
		comment: String = ""
	) {
		self.level = level
		self.source = source
		self.tags = tags
		self.details = details
		self.comment = comment
	}
}
