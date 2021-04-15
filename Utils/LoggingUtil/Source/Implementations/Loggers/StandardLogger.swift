public struct StandardLogger<LogHandlerType: LoggingUtil.LogHandler> {
	public var level: LoggingLevel
	public var source: [String]
	public var logHandler: LogHandlerType
	
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
	
	public func trace (_ message: LogHandlerType.Message, source: [String] = []) {
		log(level: .trace, message: message, source: source)
	}
	
	public func debug (_ message: LogHandlerType.Message, source: [String] = []) {
		log(level: .trace, message: message, source: source)
	}
	
	public func info (_ message: LogHandlerType.Message, source: [String] = []) {
		log(level: .trace, message: message, source: source)
	}
	
	public func notice (_ message: LogHandlerType.Message, source: [String] = []) {
		log(level: .trace, message: message, source: source)
	}
	
	public func warning (_ message: LogHandlerType.Message, source: [String] = []) {
		log(level: .trace, message: message, source: source)
	}
	
	public func fault (_ message: LogHandlerType.Message, source: [String] = []) {
		log(level: .trace, message: message, source: source)
	}
	
	public func error (_ message: LogHandlerType.Message, source: [String] = []) {
		log(level: .trace, message: message, source: source)
	}
	
	public func critical (_ message: LogHandlerType.Message, source: [String] = []) {
		log(level: .trace, message: message, source: source)
	}
}



extension StandardLogger: LogHandler {
	public func log (metaInfo: MetaInfo, logRecord: LogRecord<LogHandlerType.Message>) {
		guard metaInfo.level >= level else { return }
		
		let logRecord = LogRecord(
			timestamp: logRecord.timestamp,
			level: logRecord.level,
			message: logRecord.message,
			source: source + (logRecord.source ?? [])
		)
		
		logHandler.log(metaInfo: metaInfo, logRecord: logRecord)
	}
}
