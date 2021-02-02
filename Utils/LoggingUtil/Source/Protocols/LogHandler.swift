public protocol LogHandler {
	func log (
		level: LoggingLevel,
		message: @autoclosure () -> String,
		source: @autoclosure () -> String?,
		file: String, function: String, line: UInt
	)
}
