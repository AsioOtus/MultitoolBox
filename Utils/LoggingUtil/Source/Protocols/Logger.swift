public protocol Logger {	
	func trace (
		_ message: @autoclosure () -> String,
		source: @autoclosure () -> [String],
		tags: @autoclosure () -> Set<String>,
		details: @autoclosure () -> [String: Any],
		comment: @autoclosure () -> String,
		file: String, function: String,	line: UInt
	)
	
	func debug (
		_ message: @autoclosure () -> String,
		source: @autoclosure () -> [String],
		tags: @autoclosure () -> Set<String>,
		details: @autoclosure () -> [String: Any],
		comment: @autoclosure () -> String,
		file: String, function: String,	line: UInt
	)
	
	func info (
		_ message: @autoclosure () -> String,
		source: @autoclosure () -> [String],
		tags: @autoclosure () -> Set<String>,
		details: @autoclosure () -> [String: Any],
		comment: @autoclosure () -> String,
		file: String, function: String,	line: UInt
	)
	
	func notice (
		_ message: @autoclosure () -> String,
		source: @autoclosure () -> [String],
		tags: @autoclosure () -> Set<String>,
		details: @autoclosure () -> [String: Any],
		comment: @autoclosure () -> String,
		file: String, function: String,	line: UInt
	)
	
	func warning (
		_ message: @autoclosure () -> String,
		source: @autoclosure () -> [String],
		tags: @autoclosure () -> Set<String>,
		details: @autoclosure () -> [String: Any],
		comment: @autoclosure () -> String,
		file: String, function: String,	line: UInt
	)
	
	func fault (
		_ message: @autoclosure () -> String,
		source: @autoclosure () -> [String],
		tags: @autoclosure () -> Set<String>,
		details: @autoclosure () -> [String: Any],
		comment: @autoclosure () -> String,
		file: String, function: String,	line: UInt
	)
	
	func error (
		_ message: @autoclosure () -> String,
		source: @autoclosure () -> [String],
		tags: @autoclosure () -> Set<String>,
		details: @autoclosure () -> [String: Any],
		comment: @autoclosure () -> String,
		file: String, function: String,	line: UInt
	)
	
	func critical (
		_ message: @autoclosure () -> String,
		source: @autoclosure () -> [String],
		tags: @autoclosure () -> Set<String>,
		details: @autoclosure () -> [String: Any],
		comment: @autoclosure () -> String,
		file: String, function: String,	line: UInt
	)
}
