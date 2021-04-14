public protocol EnhancedLogHandler: LogHandler {
	associatedtype Configuration
	
	func log (
		level: LoggingLevel,
		logRecord: EnhancedLogRecord<Message>,
		configuration: Configuration?
	)
}
