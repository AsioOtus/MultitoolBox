public struct DefaultLogger: Logger, LogHandler {
	public var level: LoggingLevel
	public let source: String
	public let logHandler: LogHandler
	
	public init (level: LoggingLevel = .info, source: String, logHandler: LogHandler) {
		self.source = source
		self.level = level
		self.logHandler = logHandler
	}
	
	public static func combine (sources: [String?], with separator: String = ".") -> String {
		let preparedSources = sources.compactMap{ $0 }.map{ $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }
		return preparedSources.joined(separator: separator)
	}
	
	public func log (
		level: LoggingLevel,
		message: @autoclosure () -> String,
		source: @autoclosure () -> String? = nil,
		file: String = #file, function: String = #function, line: UInt = #line
	) {
		guard level >= self.level else { return }
		
		let source = Self.combine(sources: [self.source, source()])
		
		logHandler.log(level: level, message: message(), source: source, file: file, function: function, line: line)
	}
	
	public func trace (
		_ message: @autoclosure () -> String,
		source: @autoclosure () -> String? = nil,
		file: String = #file, function: String = #function,	line: UInt = #line
	) {
		self.log(level: .trace, message: message(), source: source(), file: file, function: function, line: line)
	}
	
	public func debug (
		_ message: @autoclosure () -> String,
		source: @autoclosure () -> String? = nil,
		file: String = #file, function: String = #function,	line: UInt = #line
	) {
		self.log(level: .debug, message: message(), source: source(), file: file, function: function, line: line)
	}
	
	public func info (
		_ message: @autoclosure () -> String,
		source: @autoclosure () -> String? = nil,
		file: String = #file, function: String = #function,	line: UInt = #line
	) {
		self.log(level: .info, message: message(), source: source(), file: file, function: function, line: line)
	}
	
	public func notice (
		_ message: @autoclosure () -> String,
		source: @autoclosure () -> String? = nil,
		file: String = #file, function: String = #function,	line: UInt = #line
	) {
		self.log(level: .notice, message: message(), source: source(), file: file, function: function, line: line)
	}
	
	public func warning (
		_ message: @autoclosure () -> String,
		source: @autoclosure () -> String? = nil,
		file: String = #file, function: String = #function,	line: UInt = #line
	) {
		self.log(level: .warning, message: message(), source: source(), file: file, function: function, line: line)
	}
	
	public func fault (
		_ message: @autoclosure () -> String,
		source: @autoclosure () -> String? = nil,
		file: String = #file, function: String = #function,	line: UInt = #line
	) {
		self.log(level: .fault, message: message(), source: source(), file: file, function: function, line: line)
	}
	
	public func error (
		_ message: @autoclosure () -> String,
		source: @autoclosure () -> String? = nil,
		file: String = #file, function: String = #function,	line: UInt = #line
	) {
		self.log(level: .error, message: message(), source: source(), file: file, function: function, line: line)
	}
	
	public func critical (
		_ message: @autoclosure () -> String,
		source: @autoclosure () -> String? = nil,
		file: String = #file, function: String = #function,	line: UInt = #line
	) {
		self.log(level: .critical, message: message(), source: source(), file: file, function: function, line: line)
	}
}
