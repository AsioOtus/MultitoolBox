public struct LogRecord<Message: Codable>: Codable {
	let level: LoggingLevel?
	let message: Message
	let source: [String]?
}
