public protocol EnhancedLogger: Logger {
	associatedtype Message
	associatedtype LogHandlerConfiguration
	
	func log (
		level: LoggingLevel,
		message: Message,
		source: [String],
		tags: Set<String>,
		details: [String: String],
		comment: String,
		file: String, function: String, line: UInt,
		logHandlerConfiguration: LogHandlerConfiguration?,
		labels: [String]
	)
	
	func trace (
		_ message: Message,
		source: [String],
		tags: Set<String>,
		details: [String: String],
		comment: String,
		file: String, function: String,	line: UInt,
		logHandlerConfiguration: LogHandlerConfiguration?
	)
	
	func debug (
		_ message: Message,
		source: [String],
		tags: Set<String>,
		details: [String: String],
		comment: String,
		file: String, function: String,	line: UInt,
		logHandlerConfiguration: LogHandlerConfiguration?
	)
	
	func info (
		_ message: Message,
		source: [String],
		tags: Set<String>,
		details: [String: String],
		comment: String,
		file: String, function: String,	line: UInt,
		logHandlerConfiguration: LogHandlerConfiguration?
	)
	
	func notice (
		_ message: Message,
		source: [String],
		tags: Set<String>,
		details: [String: String],
		comment: String,
		file: String, function: String,	line: UInt,
		logHandlerConfiguration: LogHandlerConfiguration?
	)
	
	func warning (
		_ message: Message,
		source: [String],
		tags: Set<String>,
		details: [String: String],
		comment: String,
		file: String, function: String,	line: UInt,
		logHandlerConfiguration: LogHandlerConfiguration?
	)
	
	func fault (
		_ message: Message,
		source: [String],
		tags: Set<String>,
		details: [String: String],
		comment: String,
		file: String, function: String,	line: UInt,
		logHandlerConfiguration: LogHandlerConfiguration?
	)
	
	func error (
		_ message: Message,
		source: [String],
		tags: Set<String>,
		details: [String: String],
		comment: String,
		file: String, function: String,	line: UInt,
		logHandlerConfiguration: LogHandlerConfiguration?
	)
	
	func critical (
		_ message: Message,
		source: [String],
		tags: Set<String>,
		details: [String: String],
		comment: String,
		file: String, function: String,	line: UInt,
		logHandlerConfiguration: LogHandlerConfiguration?
	)
}
