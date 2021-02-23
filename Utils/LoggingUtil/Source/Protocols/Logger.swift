public protocol Logger {
	associatedtype Message
	
	func trace (
		_ message: @autoclosure () -> Message,
		source: @autoclosure () -> [String],
		tags: @autoclosure () -> Set<String>,
		details: @autoclosure () -> [String: Any],
		comment: @autoclosure () -> String,
		file: String, function: String,	line: UInt
	)
	
	func debug (
		_ message: @autoclosure () -> Message,
		source: @autoclosure () -> [String],
		tags: @autoclosure () -> Set<String>,
		details: @autoclosure () -> [String: Any],
		comment: @autoclosure () -> String,
		file: String, function: String,	line: UInt
	)
	
	func info (
		_ message: @autoclosure () -> Message,
		source: @autoclosure () -> [String],
		tags: @autoclosure () -> Set<String>,
		details: @autoclosure () -> [String: Any],
		comment: @autoclosure () -> String,
		file: String, function: String,	line: UInt
	)
	
	func notice (
		_ message: @autoclosure () -> Message,
		source: @autoclosure () -> [String],
		tags: @autoclosure () -> Set<String>,
		details: @autoclosure () -> [String: Any],
		comment: @autoclosure () -> String,
		file: String, function: String,	line: UInt
	)
	
	func warning (
		_ message: @autoclosure () -> Message,
		source: @autoclosure () -> [String],
		tags: @autoclosure () -> Set<String>,
		details: @autoclosure () -> [String: Any],
		comment: @autoclosure () -> String,
		file: String, function: String,	line: UInt
	)
	
	func fault (
		_ message: @autoclosure () -> Message,
		source: @autoclosure () -> [String],
		tags: @autoclosure () -> Set<String>,
		details: @autoclosure () -> [String: Any],
		comment: @autoclosure () -> String,
		file: String, function: String,	line: UInt
	)
	
	func error (
		_ message: @autoclosure () -> Message,
		source: @autoclosure () -> [String],
		tags: @autoclosure () -> Set<String>,
		details: @autoclosure () -> [String: Any],
		comment: @autoclosure () -> String,
		file: String, function: String,	line: UInt
	)
	
	func critical (
		_ message: @autoclosure () -> Message,
		source: @autoclosure () -> [String],
		tags: @autoclosure () -> Set<String>,
		details: @autoclosure () -> [String: Any],
		comment: @autoclosure () -> String,
		file: String, function: String,	line: UInt
	)
}
