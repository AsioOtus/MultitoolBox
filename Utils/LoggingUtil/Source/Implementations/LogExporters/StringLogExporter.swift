public protocol StringLogExporter {
	associatedtype Configuration
	
	func log (_ level: LoggingLevel, _ message: String, _ configuration: Configuration?)
}
