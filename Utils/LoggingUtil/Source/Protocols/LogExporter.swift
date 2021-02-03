public protocol LogExporter {
	func log (_ level: LoggingLevel, _ message: String)
}
