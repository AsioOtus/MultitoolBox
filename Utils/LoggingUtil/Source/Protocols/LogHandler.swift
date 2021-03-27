public protocol LogHandler {
	associatedtype Message
	
	func log (
		level: LoggingLevel,
		message: @autoclosure () -> Message,
		source: @autoclosure () -> [String]
	)
}
