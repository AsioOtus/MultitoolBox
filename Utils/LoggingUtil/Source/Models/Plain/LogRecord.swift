public struct LogRecord<Message: Codable>: Codable {
	public let timestamp: TimeInterval?
	public let level: LoggingLevel?
	public let message: Message
	public let source: [String]?
}
