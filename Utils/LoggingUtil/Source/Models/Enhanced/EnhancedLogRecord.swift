public struct EnhancedLogRecord<Message: Codable>: Codable {
	public let level: LoggingLevel?
	public let message: Message
	public let source: [String]?
	public let tags: Set<String>?
	public let details: [String: String]?
	public let comment: String?
	public let file: String?
	public let function: String?
	public let line: UInt?
	public let labels: [String]?
	
	internal init (
		level: LoggingLevel? = nil,
		message: Message,
		source: [String]? = nil,
		tags: Set<String>? = nil,
		details: [String: String]? = nil,
		comment: String? = nil,
		file: String? = nil,
		function: String? = nil,
		line: UInt? = nil,
		labels: [String]? = nil
	) {
		self.level = level
		self.message = message
		self.source = source
		self.tags = tags
		self.details = details
		self.comment = comment
		self.file = file
		self.function = function
		self.line = line
		self.labels = labels
	}
}
