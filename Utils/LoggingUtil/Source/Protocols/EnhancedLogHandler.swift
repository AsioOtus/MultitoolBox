public protocol EnhancedLogHandler: LogHandler {
	associatedtype Message
	associatedtype Configuration
	
	func log (
		level: LoggingLevel,
		message: @autoclosure () -> Message,
		source: @autoclosure () -> [String],
		tags: @autoclosure () -> Set<String>,
		details: @autoclosure () -> [String: Any],
		comment: @autoclosure () -> String,
		file: String, function: String, line: UInt,
		logHandlerConfiguration: Configuration?,
		labels: [String]
	)
}
