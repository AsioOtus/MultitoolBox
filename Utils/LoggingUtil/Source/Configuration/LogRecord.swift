struct LogRecord {
	let level: LoggingLevel?
	let message: String
	let source: [String]?
	let tags: Set<String>?
	let details: [String: Any]?
	let comment: String?
	let file: String?
	let function: String?
	let line: UInt?
}
