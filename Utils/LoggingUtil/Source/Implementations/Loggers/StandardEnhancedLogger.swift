public class StandardEnhancedLogger <LogHandlerType: EnhancedLogHandler> {
	public var logHandler: LogHandlerType
	public var loggerInfo: EnhancedLoggerInfo
	public var logHandlerConfiguration: LogHandlerType.Configuration?
	
	
	
	public init (
		loggerInfo: EnhancedLoggerInfo = .init(),
		logHandler: LogHandlerType,
		logHandlerConfiguration: LogHandlerType.Configuration? = nil
	) {
		self.logHandler = logHandler
		self.loggerInfo = loggerInfo
		self.logHandlerConfiguration = logHandlerConfiguration
	}
}
	

	
extension StandardEnhancedLogger: EnhancedLogger {
	public func log (level: LoggingLevel, message: LogHandlerType.Message, source: [String] = []) {
		guard level >= loggerInfo.level else { return }
		
		let configuration = logHandlerConfiguration ?? self.logHandlerConfiguration
		
		let logRecord = EnhancedLogRecord(
			level: level,
			message: message,
			source: loggerInfo.source + source,
			tags: loggerInfo.tags,
			details: loggerInfo.details,
			comment: loggerInfo.comment
		)
		
		log(level: level, logRecord: logRecord, configuration: configuration)
	}
	
	public func trace (_ message: LogHandlerType.Message, source: [String] = []) {
		self.log(level: .trace, message: message, source: source, tags: [], details: [:], comment: "", file: "", function: "", line: 0)
	}
	
	public func debug (_ message: LogHandlerType.Message, source: [String] = []) {
		self.log(level: .debug, message: message, source: source, tags: [], details: [:], comment: "", file: "", function: "", line: 0)
	}
	
	public func info (_ message: LogHandlerType.Message, source: [String] = []) {
		self.log(level: .info, message: message, source: source, tags: [], details: [:], comment: "", file: "", function: "", line: 0)
	}
	
	public func notice (_ message: LogHandlerType.Message, source: [String] = []) {
		self.log(level: .notice, message: message, source: source, tags: [], details: [:], comment: "", file: "", function: "", line: 0)
	}
	
	public func warning (_ message: LogHandlerType.Message, source: [String] = []) {
		self.log(level: .warning, message: message, source: source, tags: [], details: [:], comment: "", file: "", function: "", line: 0)
	}
	
	public func fault (_ message: LogHandlerType.Message, source: [String] = []) {
		self.log(level: .fault, message: message, source: source, tags: [], details: [:], comment: "", file: "", function: "", line: 0)
	}
	
	public func error (_ message: LogHandlerType.Message, source: [String] = []) {
		self.log(level: .error, message: message, source: source, tags: [], details: [:], comment: "", file: "", function: "", line: 0)
	}
	
	public func critical (_ message: LogHandlerType.Message, source: [String] = []) {
		self.log(level: .critical, message: message, source: source, tags: [], details: [:], comment: "", file: "", function: "", line: 0)
	}
	
	public func log (
		level: LoggingLevel,
		message: LogHandlerType.Message,
		source: [String] = [],
		tags: Set<String> = [],
		details: [String: String] = [:],
		comment: String = "",
		file: String = #file, function: String = #function, line: UInt = #line,
		logHandlerConfiguration: LogHandlerType.Configuration? = nil,
		labels: [String] = []
	) {
		guard level >= loggerInfo.level else { return }
		
		let configuration = logHandlerConfiguration ?? self.logHandlerConfiguration
		
		let logRecord = EnhancedLogRecord(
			level: level,
			message: message,
			source: loggerInfo.source + source,
			tags: loggerInfo.tags.union(tags),
			details: loggerInfo.details.merging(details, uniquingKeysWith: { _, detail in detail }),
			comment: !comment.isEmpty ? comment : loggerInfo.comment,
			file: file,
			function: function,
			line: line,
			labels: [loggerInfo.label] + labels
		)
		
		logHandler.log(level: level, logRecord: logRecord, configuration: configuration)
	}
	
	public func trace (
		_ message: LogHandlerType.Message,
		source: [String] = [],
		tags: Set<String> = [],
		details: [String: String] = [:],
		comment: String = "",
		file: String = #file, function: String = #function,	line: UInt = #line,
		logHandlerConfiguration: LogHandlerType.Configuration?
	) {
		self.log(level: .trace, message: message, source: source, tags: tags, details: details, comment: comment, file: file, function: function, line: line)
	}
	
	public func debug (
		_ message: LogHandlerType.Message,
		source: [String] = [],
		tags: Set<String> = [],
		details: [String: String] = [:],
		comment: String = "",
		file: String = #file, function: String = #function,	line: UInt = #line,
		logHandlerConfiguration: LogHandlerType.Configuration?
	) {
		self.log(level: .debug, message: message, source: source, tags: tags, details: details, comment: comment, file: file, function: function, line: line)
	}
	
	public func info (
		_ message: LogHandlerType.Message,
		source: [String] = [],
		tags: Set<String> = [],
		details: [String: String] = [:],
		comment: String = "",
		file: String = #file, function: String = #function,	line: UInt = #line,
		logHandlerConfiguration: LogHandlerType.Configuration?
	) {
		self.log(level: .info, message: message, source: source, tags: tags, details: details, comment: comment, file: file, function: function, line: line)
	}
	
	public func notice (
		_ message: LogHandlerType.Message,
		source: [String] = [],
		tags: Set<String> = [],
		details: [String: String] = [:],
		comment: String = "",
		file: String = #file, function: String = #function,	line: UInt = #line,
		logHandlerConfiguration: LogHandlerType.Configuration?
	) {
		self.log(level: .notice, message: message, source: source, tags: tags, details: details, comment: comment, file: file, function: function, line: line)
	}
	
	public func warning (
		_ message: LogHandlerType.Message,
		source: [String] = [],
		tags: Set<String> = [],
		details: [String: String] = [:],
		comment: String = "",
		file: String = #file, function: String = #function,	line: UInt = #line,
		logHandlerConfiguration: LogHandlerType.Configuration?
	) {
		self.log(level: .warning, message: message, source: source, tags: tags, details: details, comment: comment, file: file, function: function, line: line)
	}
	
	public func fault (
		_ message: LogHandlerType.Message,
		source: [String] = [],
		tags: Set<String> = [],
		details: [String: String] = [:],
		comment: String = "",
		file: String = #file, function: String = #function,	line: UInt = #line,
		logHandlerConfiguration: LogHandlerType.Configuration?
	) {
		self.log(level: .fault, message: message, source: source, tags: tags, details: details, comment: comment, file: file, function: function, line: line)
	}
	
	public func error (
		_ message: LogHandlerType.Message,
		source: [String] = [],
		tags: Set<String> = [],
		details: [String: String] = [:],
		comment: String = "",
		file: String = #file, function: String = #function,	line: UInt = #line,
		logHandlerConfiguration: LogHandlerType.Configuration?
	) {
		self.log(level: .error, message: message, source: source, tags: tags, details: details, comment: comment, file: file, function: function, line: line)
	}
	
	public func critical (
		_ message: LogHandlerType.Message,
		source: [String] = [],
		tags: Set<String> = [],
		details: [String: String] = [:],
		comment: String = "",
		file: String = #file, function: String = #function,	line: UInt = #line,
		logHandlerConfiguration: LogHandlerType.Configuration?
	) {
		self.log(level: .critical, message: message, source: source, tags: tags, details: details, comment: comment, file: file, function: function, line: line)
	}
}



extension StandardEnhancedLogger: EnhancedLogHandler {	
	public func log (level: LoggingLevel, logRecord: LogRecord<LogHandlerType.Message>) {
		logHandler.log(level: level, logRecord: logRecord)
	}
	
	public func log (level: LoggingLevel, logRecord: EnhancedLogRecord<LogHandlerType.Message>, configuration: LogHandlerType.Configuration? = nil) {
		logHandler.log(level: level, logRecord: logRecord, configuration: configuration)
	}
}
