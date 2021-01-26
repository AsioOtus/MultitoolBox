protocol Logger {	
	func log (
		level: LogLevel,
		message: @autoclosure () -> String,
		source: @autoclosure () -> String?,
		file: String, function: String, line: UInt
	)
	
	func trace (
		_ message: @autoclosure () -> String,
		source: @autoclosure () -> String?,
		file: String, function: String,	line: UInt
	)
	
	func debug (
		_ message: @autoclosure () -> String,
		source: @autoclosure () -> String?,
		file: String, function: String,	line: UInt
	)
	
	func info (
		_ message: @autoclosure () -> String,
		source: @autoclosure () -> String?,
		file: String, function: String,	line: UInt
	)
	
	func notice (
		_ message: @autoclosure () -> String,
		source: @autoclosure () -> String?,
		file: String, function: String,	line: UInt
	)
	
	func warning (
		_ message: @autoclosure () -> String,
		source: @autoclosure () -> String?,
		file: String, function: String,	line: UInt
	)
	
	func fault (
		_ message: @autoclosure () -> String,
		source: @autoclosure () -> String?,
		file: String, function: String,	line: UInt
	)
	
	func error (
		_ message: @autoclosure () -> String,
		source: @autoclosure () -> String?,
		file: String, function: String,	line: UInt
	)
	
	func critical (
		_ message: @autoclosure () -> String,
		source: @autoclosure () -> String?,
		file: String, function: String,	line: UInt
	)
}
