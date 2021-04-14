public struct EnhancedLoggerInfo {
	public var level: LoggingLevel
	public var source: [String]
	public var tags: Set<String>
	public var details: [String: String]
	public var comment: String
	public var label: String
	
	public init (
		level: LoggingLevel = .info,
		source: [String] = [],
		tags: Set<String> = [],
		details: [String: String] = [:],
		comment: String = "",
		label: String = "\(#file) – \(#line)"
	) {
		self.level = level
		self.source = source
		self.tags = tags
		self.details = details
		self.comment = comment
		self.label = label
	}
}
