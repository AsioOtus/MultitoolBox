public class DefaultLogger <LogHandlerType: LoggingUtil.LogHandler> {
	public var logHandler: LogHandlerType
	public var loggerInfo: LoggerInfo
	public var logHandlerConfiguration: LogHandlerType.Configuration?
	
	
	
	public init (
		logHandler: LogHandlerType,
		loggerInfo: LoggerInfo = .init(),
		logHandlerConfiguration: LogHandlerType.Configuration? = nil
	) {
		self.logHandler = logHandler
		self.loggerInfo = loggerInfo
		self.logHandlerConfiguration = logHandlerConfiguration
	}
}
	

	
extension DefaultLogger: Logger {
	public func trace (
		_ message: @autoclosure () -> LogHandlerType.Message,
		source: @autoclosure () -> [String] = [],
		tags: @autoclosure () -> Set<String> = [],
		details: @autoclosure () -> [String: Any] = [:],
		comment: @autoclosure () -> String = "",
		file: String = #file, function: String = #function,	line: UInt = #line
	) {
		self.log(level: .trace, message: message(), source: source(), tags: tags(), details: details(), comment: comment(), file: file, function: function, line: line)
	}
	
	public func debug (
		_ message: @autoclosure () -> LogHandlerType.Message,
		source: @autoclosure () -> [String] = [],
		tags: @autoclosure () -> Set<String> = [],
		details: @autoclosure () -> [String: Any] = [:],
		comment: @autoclosure () -> String = "",
		file: String = #file, function: String = #function,	line: UInt = #line
	) {
		self.log(level: .debug, message: message(), source: source(), tags: tags(), details: details(), comment: comment(), file: file, function: function, line: line)
	}
	
	public func info (
		_ message: @autoclosure () -> LogHandlerType.Message,
		source: @autoclosure () -> [String] = [],
		tags: @autoclosure () -> Set<String> = [],
		details: @autoclosure () -> [String: Any] = [:],
		comment: @autoclosure () -> String = "",
		file: String = #file, function: String = #function,	line: UInt = #line
	) {
		self.log(level: .info, message: message(), source: source(), tags: tags(), details: details(), comment: comment(), file: file, function: function, line: line)
	}
	
	public func notice (
		_ message: @autoclosure () -> LogHandlerType.Message,
		source: @autoclosure () -> [String] = [],
		tags: @autoclosure () -> Set<String> = [],
		details: @autoclosure () -> [String: Any] = [:],
		comment: @autoclosure () -> String = "",
		file: String = #file, function: String = #function,	line: UInt = #line
	) {
		self.log(level: .notice, message: message(), source: source(), tags: tags(), details: details(), comment: comment(), file: file, function: function, line: line)
	}
	
	public func warning (
		_ message: @autoclosure () -> LogHandlerType.Message,
		source: @autoclosure () -> [String] = [],
		tags: @autoclosure () -> Set<String> = [],
		details: @autoclosure () -> [String: Any] = [:],
		comment: @autoclosure () -> String = "",
		file: String = #file, function: String = #function,	line: UInt = #line
	) {
		self.log(level: .warning, message: message(), source: source(), tags: tags(), details: details(), comment: comment(), file: file, function: function, line: line)
	}
	
	public func fault (
		_ message: @autoclosure () -> LogHandlerType.Message,
		source: @autoclosure () -> [String] = [],
		tags: @autoclosure () -> Set<String> = [],
		details: @autoclosure () -> [String: Any] = [:],
		comment: @autoclosure () -> String = "",
		file: String = #file, function: String = #function,	line: UInt = #line
	) {
		self.log(level: .fault, message: message(), source: source(), tags: tags(), details: details(), comment: comment(), file: file, function: function, line: line)
	}
	
	public func error (
		_ message: @autoclosure () -> LogHandlerType.Message,
		source: @autoclosure () -> [String] = [],
		tags: @autoclosure () -> Set<String> = [],
		details: @autoclosure () -> [String: Any] = [:],
		comment: @autoclosure () -> String = "",
		file: String = #file, function: String = #function,	line: UInt = #line
	) {
		self.log(level: .error, message: message(), source: source(), tags: tags(), details: details(), comment: comment(), file: file, function: function, line: line)
	}
	
	public func critical (
		_ message: @autoclosure () -> LogHandlerType.Message,
		source: @autoclosure () -> [String] = [],
		tags: @autoclosure () -> Set<String> = [],
		details: @autoclosure () -> [String: Any] = [:],
		comment: @autoclosure () -> String = "",
		file: String = #file, function: String = #function,	line: UInt = #line
	) {
		self.log(level: .critical, message: message(), source: source(), tags: tags(), details: details(), comment: comment(), file: file, function: function, line: line)
	}
}



extension DefaultLogger: LogHandler {
	public func log (
		level: LoggingLevel,
		message: @autoclosure () -> LogHandlerType.Message,
		source: @autoclosure () -> [String] = [],
		tags: @autoclosure () -> Set<String> = [],
		details: @autoclosure () -> [String: Any] = [:],
		comment: @autoclosure () -> String = "",
		file: String = #file, function: String = #function, line: UInt = #line,
		logHandlerConfiguration: LogHandlerType.Configuration? = nil
	) {
		guard level >= loggerInfo.level else { return }
		
		let source = (loggerInfo.source + source()).combine()
		let tags = loggerInfo.tags.union(tags())
		let details = loggerInfo.details.merging(details(), uniquingKeysWith: { _, detail in detail })
		let comment = !comment().isEmpty ? comment() : loggerInfo.comment
		let configuration = logHandlerConfiguration ?? self.logHandlerConfiguration
		
		logHandler.log(level: level, message: message(), source: [source], tags: tags, details: details, comment: comment, file: file, function: function, line: line, logHandlerConfiguration: configuration)
	}
}
