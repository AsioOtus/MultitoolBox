public class DefaultEnhancedLogger <LogHandlerType: LoggingUtil.EnhancedLogHandler> {
	public var label: String
	public var logHandler: LogHandlerType
	public var loggerInfo: EnhancedLoggerInfo
	public var logHandlerConfiguration: LogHandlerType.Configuration?
	
	
	
	public init (
		label: String = "\(#file) – \(#line)",
		loggerInfo: EnhancedLoggerInfo = .init(),
		logHandler: LogHandlerType,
		logHandlerConfiguration: LogHandlerType.Configuration? = nil
	) {
		self.label = label
		self.logHandler = logHandler
		self.loggerInfo = loggerInfo
		self.logHandlerConfiguration = logHandlerConfiguration
	}
}
	

	
extension DefaultEnhancedLogger: EnhancedLogger {
	public func trace (_ message: @autoclosure () -> LogHandlerType.Message, source: @autoclosure () -> [String]) {
		self.log(level: .trace, message: message(), source: source(), tags: [], details: [:], comment: "", file: "", function: "", line: 0)
	}
	
	public func debug (_ message: @autoclosure () -> LogHandlerType.Message, source: @autoclosure () -> [String]) {
		self.log(level: .debug, message: message(), source: source(), tags: [], details: [:], comment: "", file: "", function: "", line: 0)
	}
	
	public func info (_ message: @autoclosure () -> LogHandlerType.Message, source: @autoclosure () -> [String]) {
		self.log(level: .info, message: message(), source: source(), tags: [], details: [:], comment: "", file: "", function: "", line: 0)
	}
	
	public func notice (_ message: @autoclosure () -> LogHandlerType.Message, source: @autoclosure () -> [String]) {
		self.log(level: .notice, message: message(), source: source(), tags: [], details: [:], comment: "", file: "", function: "", line: 0)
	}
	
	public func warning (_ message: @autoclosure () -> LogHandlerType.Message, source: @autoclosure () -> [String]) {
		self.log(level: .warning, message: message(), source: source(), tags: [], details: [:], comment: "", file: "", function: "", line: 0)
	}
	
	public func fault (_ message: @autoclosure () -> LogHandlerType.Message, source: @autoclosure () -> [String]) {
		self.log(level: .fault, message: message(), source: source(), tags: [], details: [:], comment: "", file: "", function: "", line: 0)
	}
	
	public func error (_ message: @autoclosure () -> LogHandlerType.Message, source: @autoclosure () -> [String]) {
		self.log(level: .error, message: message(), source: source(), tags: [], details: [:], comment: "", file: "", function: "", line: 0)
	}
	
	public func critical (_ message: @autoclosure () -> LogHandlerType.Message, source: @autoclosure () -> [String]) {
		self.log(level: .critical, message: message(), source: source(), tags: [], details: [:], comment: "", file: "", function: "", line: 0)
	}
	
	public func trace (
		_ message: @autoclosure () -> LogHandlerType.Message,
		source: @autoclosure () -> [String] = [],
		tags: @autoclosure () -> Set<String> = [],
		details: @autoclosure () -> [String: Any] = [:],
		comment: @autoclosure () -> String = "",
		file: String = #file, function: String = #function,	line: UInt = #line,
		logHandlerConfiguration: LogHandlerType.Configuration?
	) {
		self.log(level: .trace, message: message(), source: source(), tags: tags(), details: details(), comment: comment(), file: file, function: function, line: line)
	}
	
	public func debug (
		_ message: @autoclosure () -> LogHandlerType.Message,
		source: @autoclosure () -> [String] = [],
		tags: @autoclosure () -> Set<String> = [],
		details: @autoclosure () -> [String: Any] = [:],
		comment: @autoclosure () -> String = "",
		file: String = #file, function: String = #function,	line: UInt = #line,
		logHandlerConfiguration: LogHandlerType.Configuration?
	) {
		self.log(level: .debug, message: message(), source: source(), tags: tags(), details: details(), comment: comment(), file: file, function: function, line: line)
	}
	
	public func info (
		_ message: @autoclosure () -> LogHandlerType.Message,
		source: @autoclosure () -> [String] = [],
		tags: @autoclosure () -> Set<String> = [],
		details: @autoclosure () -> [String: Any] = [:],
		comment: @autoclosure () -> String = "",
		file: String = #file, function: String = #function,	line: UInt = #line,
		logHandlerConfiguration: LogHandlerType.Configuration?
	) {
		self.log(level: .info, message: message(), source: source(), tags: tags(), details: details(), comment: comment(), file: file, function: function, line: line)
	}
	
	public func notice (
		_ message: @autoclosure () -> LogHandlerType.Message,
		source: @autoclosure () -> [String] = [],
		tags: @autoclosure () -> Set<String> = [],
		details: @autoclosure () -> [String: Any] = [:],
		comment: @autoclosure () -> String = "",
		file: String = #file, function: String = #function,	line: UInt = #line,
		logHandlerConfiguration: LogHandlerType.Configuration?
	) {
		self.log(level: .notice, message: message(), source: source(), tags: tags(), details: details(), comment: comment(), file: file, function: function, line: line)
	}
	
	public func warning (
		_ message: @autoclosure () -> LogHandlerType.Message,
		source: @autoclosure () -> [String] = [],
		tags: @autoclosure () -> Set<String> = [],
		details: @autoclosure () -> [String: Any] = [:],
		comment: @autoclosure () -> String = "",
		file: String = #file, function: String = #function,	line: UInt = #line,
		logHandlerConfiguration: LogHandlerType.Configuration?
	) {
		self.log(level: .warning, message: message(), source: source(), tags: tags(), details: details(), comment: comment(), file: file, function: function, line: line)
	}
	
	public func fault (
		_ message: @autoclosure () -> LogHandlerType.Message,
		source: @autoclosure () -> [String] = [],
		tags: @autoclosure () -> Set<String> = [],
		details: @autoclosure () -> [String: Any] = [:],
		comment: @autoclosure () -> String = "",
		file: String = #file, function: String = #function,	line: UInt = #line,
		logHandlerConfiguration: LogHandlerType.Configuration?
	) {
		self.log(level: .fault, message: message(), source: source(), tags: tags(), details: details(), comment: comment(), file: file, function: function, line: line)
	}
	
	public func error (
		_ message: @autoclosure () -> LogHandlerType.Message,
		source: @autoclosure () -> [String] = [],
		tags: @autoclosure () -> Set<String> = [],
		details: @autoclosure () -> [String: Any] = [:],
		comment: @autoclosure () -> String = "",
		file: String = #file, function: String = #function,	line: UInt = #line,
		logHandlerConfiguration: LogHandlerType.Configuration?
	) {
		self.log(level: .error, message: message(), source: source(), tags: tags(), details: details(), comment: comment(), file: file, function: function, line: line)
	}
	
	public func critical (
		_ message: @autoclosure () -> LogHandlerType.Message,
		source: @autoclosure () -> [String] = [],
		tags: @autoclosure () -> Set<String> = [],
		details: @autoclosure () -> [String: Any] = [:],
		comment: @autoclosure () -> String = "",
		file: String = #file, function: String = #function,	line: UInt = #line,
		logHandlerConfiguration: LogHandlerType.Configuration?
	) {
		self.log(level: .critical, message: message(), source: source(), tags: tags(), details: details(), comment: comment(), file: file, function: function, line: line)
	}
}



extension DefaultEnhancedLogger: EnhancedLogHandler {
	public func log (level: LoggingLevel, message: @autoclosure () -> LogHandlerType.Message, source: @autoclosure () -> [String]) {
		guard level >= loggerInfo.level else { return }
		
		let source = loggerInfo.source + source()
		let tags = loggerInfo.tags
		let details = loggerInfo.details
		let comment = loggerInfo.comment
		let configuration = logHandlerConfiguration ?? self.logHandlerConfiguration
		
		logHandler.log(
			level: level,
			message: message(),
			source: source,
			tags: tags,
			details: details,
			comment: comment,
			file: "", function: "", line: 0,
			logHandlerConfiguration: configuration,
			labels: []
		)
	}
	
	public func log (
		level: LoggingLevel,
		message: @autoclosure () -> LogHandlerType.Message,
		source: @autoclosure () -> [String] = [],
		tags: @autoclosure () -> Set<String> = [],
		details: @autoclosure () -> [String: Any] = [:],
		comment: @autoclosure () -> String = "",
		file: String = #file, function: String = #function, line: UInt = #line,
		logHandlerConfiguration: LogHandlerType.Configuration? = nil,
		labels: [String] = []
	) {
		guard level >= loggerInfo.level else { return }
		
		let source = loggerInfo.source + source()
		let tags = loggerInfo.tags.union(tags())
		let details = loggerInfo.details.merging(details(), uniquingKeysWith: { _, detail in detail })
		let comment = !comment().isEmpty ? comment() : loggerInfo.comment
		let configuration = logHandlerConfiguration ?? self.logHandlerConfiguration
		
		logHandler.log(level: level, message: message(), source: source, tags: tags, details: details, comment: comment, file: file, function: function, line: line, logHandlerConfiguration: configuration, labels: [label] + labels)
	}
}
