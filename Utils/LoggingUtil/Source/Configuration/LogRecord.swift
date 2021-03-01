struct LogRecord<Message> {
	let level: LoggingLevel?
	let message: Message
	let source: [String]?
	let tags: Set<String>?
	let details: [String: Any]?
	let comment: String?
	let file: String?
	let function: String?
	let line: UInt?
}
