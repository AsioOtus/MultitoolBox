public class StandardEnhancedLogger <LogHandlerType: EnhancedLogHandler> {
	public var loggerInfo: EnhancedLoggerInfo
	public var logHandler: LogHandlerType
	
	
	public init (
		loggerInfo: EnhancedLoggerInfo = .init(),
		logHandler: LogHandlerType
	) {
		self.loggerInfo = loggerInfo
		self.logHandler = logHandler
	}
}
	

	
extension StandardEnhancedLogger: EnhancedLogger {
	public func log (level: LoggingLevel, message: LogHandlerType.Message, source: [String] = []) {
		let metaInfo = MetaInfo(timestamp: Date().timeIntervalSince1970, level: level)
		
		let logRecord = LogRecord(
			timestamp: metaInfo.timestamp,
			level: level,
			message: message,
			source: source
		)
		
		log(metaInfo: metaInfo, logRecord: logRecord)
	}
	
	public func log (
		level: LoggingLevel,
		message: LogHandlerType.Message,
		source: [String] = [],
		tags: Set<String> = [],
		details: [String: String] = [:],
		comment: String = "",
		file: String = #file, function: String = #function, line: UInt = #line
	) {
		let metaInfo = EnhancedMetaInfo(timestamp: Date().timeIntervalSince1970, level: level, labels: [])
		
		let logRecord = EnhancedLogRecord(
			timestamp: metaInfo.timestamp,
			level: level,
			message: message,
			source: source,
			tags: tags,
			details: details,
			comment: comment,
			file: file,
			function: function,
			line: line
		)
		
		log(metaInfo: metaInfo, logRecord: logRecord)
	}
	
	public func trace (
		_ message: LogHandlerType.Message,
		source: [String] = [],
		tags: Set<String> = [],
		details: [String: String] = [:],
		comment: String = "",
		file: String = #file, function: String = #function,	line: UInt = #line
	) {
		log(level: .trace, message: message, source: source, tags: tags, details: details, comment: comment, file: file, function: function, line: line)
	}
	
	public func debug (
		_ message: LogHandlerType.Message,
		source: [String] = [],
		tags: Set<String> = [],
		details: [String: String] = [:],
		comment: String = "",
		file: String = #file, function: String = #function,	line: UInt = #line
	) {
		log(level: .debug, message: message, source: source, tags: tags, details: details, comment: comment, file: file, function: function, line: line)
	}
	
	public func info (
		_ message: LogHandlerType.Message,
		source: [String] = [],
		tags: Set<String> = [],
		details: [String: String] = [:],
		comment: String = "",
		file: String = #file, function: String = #function,	line: UInt = #line
	) {
		log(level: .info, message: message, source: source, tags: tags, details: details, comment: comment, file: file, function: function, line: line)
	}
	
	public func notice (
		_ message: LogHandlerType.Message,
		source: [String] = [],
		tags: Set<String> = [],
		details: [String: String] = [:],
		comment: String = "",
		file: String = #file, function: String = #function,	line: UInt = #line
	) {
		log(level: .notice, message: message, source: source, tags: tags, details: details, comment: comment, file: file, function: function, line: line)
	}
	
	public func warning (
		_ message: LogHandlerType.Message,
		source: [String] = [],
		tags: Set<String> = [],
		details: [String: String] = [:],
		comment: String = "",
		file: String = #file, function: String = #function,	line: UInt = #line
	) {
		log(level: .warning, message: message, source: source, tags: tags, details: details, comment: comment, file: file, function: function, line: line)
	}
	
	public func fault (
		_ message: LogHandlerType.Message,
		source: [String] = [],
		tags: Set<String> = [],
		details: [String: String] = [:],
		comment: String = "",
		file: String = #file, function: String = #function,	line: UInt = #line
	) {
		log(level: .fault, message: message, source: source, tags: tags, details: details, comment: comment, file: file, function: function, line: line)
	}
	
	public func error (
		_ message: LogHandlerType.Message,
		source: [String] = [],
		tags: Set<String> = [],
		details: [String: String] = [:],
		comment: String = "",
		file: String = #file, function: String = #function,	line: UInt = #line
	) {
		log(level: .error, message: message, source: source, tags: tags, details: details, comment: comment, file: file, function: function, line: line)
	}
	
	public func critical (
		_ message: LogHandlerType.Message,
		source: [String] = [],
		tags: Set<String> = [],
		details: [String: String] = [:],
		comment: String = "",
		file: String = #file, function: String = #function,	line: UInt = #line
	) {
		log(level: .critical, message: message, source: source, tags: tags, details: details, comment: comment, file: file, function: function, line: line)
	}
}



extension StandardEnhancedLogger: EnhancedLogHandler {
	public func log (metaInfo: EnhancedMetaInfo, logRecord: EnhancedLogRecord<Message>) {
		guard metaInfo.level >= loggerInfo.level else { return }
		
		let metaInfo = EnhancedMetaInfo(timestamp: metaInfo.timestamp, level: metaInfo.level, labels: [loggerInfo.label] + metaInfo.labels)
		let logRecord = EnhancedLogRecordCombiner.default.combine(logRecord, loggerInfo)
		
		logHandler.log(metaInfo: metaInfo, logRecord: logRecord)
	}
}
