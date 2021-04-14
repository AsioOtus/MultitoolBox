public protocol Logger {
	associatedtype Message
	
	func log (
		level: LoggingLevel,
		message: Message,
		source: [String]
	)
	
	func trace (
		_ message: Message,
		source: [String]
	)
	
	func debug (
		_ message: Message,
		source: [String]
	)
	
	func info (
		_ message: Message,
		source: [String]
	)
	
	func notice (
		_ message: Message,
		source: [String]
	)
	
	func warning (
		_ message: Message,
		source: [String]
	)
	
	func fault (
		_ message: Message,
		source: [String]
	)
	
	func error (
		_ message: Message,
		source: [String]
	)
	
	func critical (
		_ message: Message,
		source: [String]
	)
}
