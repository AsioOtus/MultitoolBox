public protocol EnhancedLogger: Logger {
	associatedtype Message
	
	func log (
		level: LoggingLevel,
		message: Message,
		source: [String],
		tags: Set<String>,
		details: [String: String],
		comment: String,
		file: String, function: String, line: UInt
	)
	
	func trace (
		_ message: Message,
		source: [String],
		tags: Set<String>,
		details: [String: String],
		comment: String,
		file: String, function: String,	line: UInt
	)
	
	func debug (
		_ message: Message,
		source: [String],
		tags: Set<String>,
		details: [String: String],
		comment: String,
		file: String, function: String,	line: UInt
	)
	
	func info (
		_ message: Message,
		source: [String],
		tags: Set<String>,
		details: [String: String],
		comment: String,
		file: String, function: String,	line: UInt
	)
	
	func notice (
		_ message: Message,
		source: [String],
		tags: Set<String>,
		details: [String: String],
		comment: String,
		file: String, function: String,	line: UInt
	)
	
	func warning (
		_ message: Message,
		source: [String],
		tags: Set<String>,
		details: [String: String],
		comment: String,
		file: String, function: String,	line: UInt
	)
	
	func fault (
		_ message: Message,
		source: [String],
		tags: Set<String>,
		details: [String: String],
		comment: String,
		file: String, function: String,	line: UInt
	)
	
	func error (
		_ message: Message,
		source: [String],
		tags: Set<String>,
		details: [String: String],
		comment: String,
		file: String, function: String,	line: UInt
	)
	
	func critical (
		_ message: Message,
		source: [String],
		tags: Set<String>,
		details: [String: String],
		comment: String,
		file: String, function: String,	line: UInt
	)
}
