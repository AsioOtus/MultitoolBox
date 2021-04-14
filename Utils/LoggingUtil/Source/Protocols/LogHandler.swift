public protocol LogHandler {
	associatedtype Message: Codable
	
	func log (level: LoggingLevel, logRecord: LogRecord<Message>)
}
