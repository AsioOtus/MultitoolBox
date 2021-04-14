struct StandardLogger<LogHandlerType: LoggingUtil.LogHandler> {
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
	func log (level: LoggingLevel, message: LogHandlerType.Message, source: [String]) {
		guard level >= level else { return }
		
		let logRecord = LogRecord(
			level: level,
			message: message,
			source: self.source + source
		)
		
		log(level: level, logRecord: logRecord)
	}
	
	func trace (_ message: LogHandlerType.Message, source: [String]) {
		log(level: .trace, message: message, source: source)
	}
	
	func debug (_ message: LogHandlerType.Message, source: [String]) {
		log(level: .trace, message: message, source: source)
	}
	
	func info (_ message: LogHandlerType.Message, source: [String]) {
		log(level: .trace, message: message, source: source)
	}
	
	func notice (_ message: LogHandlerType.Message, source: [String]) {
		log(level: .trace, message: message, source: source)
	}
	
	func warning (_ message: LogHandlerType.Message, source: [String]) {
		log(level: .trace, message: message, source: source)
	}
	
	func fault (_ message: LogHandlerType.Message, source: [String]) {
		log(level: .trace, message: message, source: source)
	}
	
	func error (_ message: LogHandlerType.Message, source: [String]) {
		log(level: .trace, message: message, source: source)
	}
	
	func critical (_ message: LogHandlerType.Message, source: [String]) {
		log(level: .trace, message: message, source: source)
	}
}



extension StandardLogger: LogHandler {
	func log (level: LoggingLevel, logRecord: LogRecord<LogHandlerType.Message>) {
		logHandler.log(level: level, logRecord: logRecord)
	}
}
