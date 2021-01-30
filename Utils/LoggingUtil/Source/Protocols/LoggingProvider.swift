public protocol LoggingProvider {
	func log (_ level: LoggingLevel, _ message: String)
}
