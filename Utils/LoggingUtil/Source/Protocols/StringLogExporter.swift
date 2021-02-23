public protocol StringLogExporter {
	func log (_ level: LoggingLevel, _ message: String)
}
