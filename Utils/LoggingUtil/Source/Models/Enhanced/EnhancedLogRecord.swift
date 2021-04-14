public struct EnhancedLogRecord<Message: Codable>: Codable {
	let level: LoggingLevel?
	let message: Message
	let source: [String]?
	let tags: Set<String>?
	let details: [String: String]?
	let comment: String?
	let file: String?
	let function: String?
	let line: UInt?
	let labels: [String]?
	
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
