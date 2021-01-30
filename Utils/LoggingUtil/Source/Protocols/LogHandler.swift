public protocol LogHandler {
	func log (_ level: LoggingLevel, _ source: String, _ message: String, _ file: String, _ function: String, _ line: UInt)
}
