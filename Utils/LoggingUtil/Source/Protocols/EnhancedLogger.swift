public protocol EnhancedLogger: Logger {
	associatedtype Message
	associatedtype LogHandlerConfiguration
	
	func trace (
		_ message: @autoclosure () -> Message,
		source: @autoclosure () -> [String],
		tags: @autoclosure () -> Set<String>,
		details: @autoclosure () -> [String: Any],
		comment: @autoclosure () -> String,
		file: String, function: String,	line: UInt,
		logHandlerConfiguration: LogHandlerConfiguration?
	)
	
	func debug (
		_ message: @autoclosure () -> Message,
		source: @autoclosure () -> [String],
		tags: @autoclosure () -> Set<String>,
		details: @autoclosure () -> [String: Any],
		comment: @autoclosure () -> String,
		file: String, function: String,	line: UInt,
		logHandlerConfiguration: LogHandlerConfiguration?
	)
	
	func info (
		_ message: @autoclosure () -> Message,
		source: @autoclosure () -> [String],
		tags: @autoclosure () -> Set<String>,
		details: @autoclosure () -> [String: Any],
		comment: @autoclosure () -> String,
		file: String, function: String,	line: UInt,
		logHandlerConfiguration: LogHandlerConfiguration?
	)
	
	func notice (
		_ message: @autoclosure () -> Message,
		source: @autoclosure () -> [String],
		tags: @autoclosure () -> Set<String>,
		details: @autoclosure () -> [String: Any],
		comment: @autoclosure () -> String,
		file: String, function: String,	line: UInt,
		logHandlerConfiguration: LogHandlerConfiguration?
	)
	
	func warning (
		_ message: @autoclosure () -> Message,
		source: @autoclosure () -> [String],
		tags: @autoclosure () -> Set<String>,
		details: @autoclosure () -> [String: Any],
		comment: @autoclosure () -> String,
		file: String, function: String,	line: UInt,
		logHandlerConfiguration: LogHandlerConfiguration?
	)
	
	func fault (
		_ message: @autoclosure () -> Message,
		source: @autoclosure () -> [String],
		tags: @autoclosure () -> Set<String>,
		details: @autoclosure () -> [String: Any],
		comment: @autoclosure () -> String,
		file: String, function: String,	line: UInt,
		logHandlerConfiguration: LogHandlerConfiguration?
	)
	
	func error (
		_ message: @autoclosure () -> Message,
		source: @autoclosure () -> [String],
		tags: @autoclosure () -> Set<String>,
		details: @autoclosure () -> [String: Any],
		comment: @autoclosure () -> String,
		file: String, function: String,	line: UInt,
		logHandlerConfiguration: LogHandlerConfiguration?
	)
	
	func critical (
		_ message: @autoclosure () -> Message,
		source: @autoclosure () -> [String],
		tags: @autoclosure () -> Set<String>,
		details: @autoclosure () -> [String: Any],
		comment: @autoclosure () -> String,
		file: String, function: String,	line: UInt,
		logHandlerConfiguration: LogHandlerConfiguration?
	)
}
