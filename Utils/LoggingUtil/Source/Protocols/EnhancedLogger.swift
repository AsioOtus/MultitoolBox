public protocol EnhancedLogger: Logger {	
	func log (
		level: LoggingLevel,
		message: Message,
		source: [String],
		tags: Set<String>,
		details: [String: String],
		comment: String,
		file: String, function: String, line: UInt
	)
	
	func trace (
		_ message: Message,
		source: [String],
		tags: Set<String>,
		details: [String: String],
		comment: String,
		file: String, function: String,	line: UInt
	)
	
	func debug (
		_ message: Message,
		source: [String],
		tags: Set<String>,
		details: [String: String],
		comment: String,
		file: String, function: String,	line: UInt
	)
	
	func info (
		_ message: Message,
		source: [String],
		tags: Set<String>,
		details: [String: String],
		comment: String,
		file: String, function: String,	line: UInt
	)
	
	func notice (
		_ message: Message,
		source: [String],
		tags: Set<String>,
		details: [String: String],
		comment: String,
		file: String, function: String,	line: UInt
	)
	
	func warning (
		_ message: Message,
		source: [String],
		tags: Set<String>,
		details: [String: String],
		comment: String,
		file: String, function: String,	line: UInt
	)
	
	func fault (
		_ message: Message,
		source: [String],
		tags: Set<String>,
		details: [String: String],
		comment: String,
		file: String, function: String,	line: UInt
	)
	
	func error (
		_ message: Message,
		source: [String],
		tags: Set<String>,
		details: [String: String],
		comment: String,
		file: String, function: String,	line: UInt
	)
	
	func critical (
		_ message: Message,
		source: [String],
		tags: Set<String>,
		details: [String: String],
		comment: String,
		file: String, function: String,	line: UInt
	)
}

extension EnhancedLogger {
	public func trace (_ message: Message, source: [String] = []) {
		log(level: .trace, message: message, source: source)
	}
	
	public func debug (_ message: Message, source: [String] = []) {
		log(level: .debug, message: message, source: source)
	}
	
	public func info (_ message: Message, source: [String] = []) {
		log(level: .info, message: message, source: source)
	}
	
	public func notice (_ message: Message, source: [String] = []) {
		log(level: .notice, message: message, source: source)
	}
	
	public func warning (_ message: Message, source: [String] = []) {
		log(level: .warning, message: message, source: source)
	}
	
	public func fault (_ message: Message, source: [String] = []) {
		log(level: .fault, message: message, source: source)
	}
	
	public func error (_ message: Message, source: [String] = []) {
		log(level: .error, message: message, source: source)
	}
	
	public func critical (_ message: Message, source: [String] = []) {
		log(level: .critical, message: message, source: source)
	}
}
