public protocol Logger {
	associatedtype Message
	
	func trace (
		_ message: @autoclosure () -> Message,
		source: @autoclosure () -> [String]
	)
	
	func debug (
		_ message: @autoclosure () -> Message,
		source: @autoclosure () -> [String]
	)
	
	func info (
		_ message: @autoclosure () -> Message,
		source: @autoclosure () -> [String]
	)
	
	func notice (
		_ message: @autoclosure () -> Message,
		source: @autoclosure () -> [String]
	)
	
	func warning (
		_ message: @autoclosure () -> Message,
		source: @autoclosure () -> [String]
	)
	
	func fault (
		_ message: @autoclosure () -> Message,
		source: @autoclosure () -> [String]
	)
	
	func error (
		_ message: @autoclosure () -> Message,
		source: @autoclosure () -> [String]
	)
	
	func critical (
		_ message: @autoclosure () -> Message,
		source: @autoclosure () -> [String]
	)
}
