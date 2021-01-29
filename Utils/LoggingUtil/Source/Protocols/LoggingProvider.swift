public protocol LoggingProvider {
	func log (_ level: LogLevel, _ message: String)
}
