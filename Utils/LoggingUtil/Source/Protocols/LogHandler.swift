public protocol LogHandler {
	associatedtype Message
	
	func log (
		level: LoggingLevel,
		message: @autoclosure () -> Message,
		source: @autoclosure () -> [String],
		tags: @autoclosure () -> Set<String>,
		details: @autoclosure () -> [String: Any],
		comment: @autoclosure () -> String,
		file: String, function: String, line: UInt
	)
}
