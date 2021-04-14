public struct StandardLogger<LogHandlerType: LoggingUtil.LogHandler> {
	public var logHandler: LogHandlerType
	public var level: LoggingLevel
	public var source: [String]
	
	public init (
		level: LoggingLevel = .info,
		source: [String] = [],
		logHandler: LogHandlerType
	) {
		self.level = level
		self.source = source
		self.logHandler = logHandler
	}
}



extension StandardLogger: Logger {
	public func log (level: LoggingLevel, message: LogHandlerType.Message, source: [String]) {
		guard level >= level else { return }
		
		let logRecord = LogRecord(
			level: level,
			message: message,
			source: self.source + source
		)
		
		log(level: level, logRecord: logRecord)
	}
	
	public func trace (_ message: LogHandlerType.Message, source: [String]) {
		log(level: .trace, message: message, source: source)
	}
	
	public func debug (_ message: LogHandlerType.Message, source: [String]) {
		log(level: .trace, message: message, source: source)
	}
	
	public func info (_ message: LogHandlerType.Message, source: [String]) {
		log(level: .trace, message: message, source: source)
	}
	
	public func notice (_ message: LogHandlerType.Message, source: [String]) {
		log(level: .trace, message: message, source: source)
	}
	
	public func warning (_ message: LogHandlerType.Message, source: [String]) {
		log(level: .trace, message: message, source: source)
	}
	
	public func fault (_ message: LogHandlerType.Message, source: [String]) {
		log(level: .trace, message: message, source: source)
	}
	
	public func error (_ message: LogHandlerType.Message, source: [String]) {
		log(level: .trace, message: message, source: source)
	}
	
	public func critical (_ message: LogHandlerType.Message, source: [String]) {
		log(level: .trace, message: message, source: source)
	}
}



extension StandardLogger: LogHandler {
	public func log (level: LoggingLevel, logRecord: LogRecord<LogHandlerType.Message>) {
		logHandler.log(level: level, logRecord: logRecord)
	}
}
