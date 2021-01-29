public struct DefaultLogger: Logger {
	public let source: String
	public let logHandler: LogHandler
	
	public var level = LogLevel.info
	
	public init (level: LogLevel = .info, source: String, logHandler: LogHandler) {
		self.source = source
		self.level = level
		self.logHandler = logHandler
	}
	
	public func log (
		level: LogLevel,
		message: @autoclosure () -> String,
		source: @autoclosure () -> String? = nil,
		file: String = #file, function: String = #function, line: UInt = #line
	) {
		guard level >= self.level else { return }
		
		let finalSource: String
		if let source = source() {
			finalSource = self.source + (!self.source.isEmpty && !source.isEmpty ? "." : "") + source
		} else {
			finalSource = self.source
		}
		
		logHandler.log(level, finalSource, message(), file, function, line)
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
