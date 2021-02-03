public protocol LogHandler {
	func log (
		level: LoggingLevel,
		message: @autoclosure () -> String,
		source: @autoclosure () -> [String],
		tags: @autoclosure () -> Set<String>,
		details: @autoclosure () -> [String: Any],
		comment: @autoclosure () -> String,
		file: String, function: String, line: UInt
	)
}
