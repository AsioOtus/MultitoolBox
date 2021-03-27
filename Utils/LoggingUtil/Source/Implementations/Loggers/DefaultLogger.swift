struct DefaultLogger<LogHandlerType: LoggingUtil.LogHandler> {
	public var logHandler: LogHandlerType
	public var loggerInfo: LoggerInfo
	
	public init (
		loggerInfo: LoggerInfo = .init(),
		logHandler: LogHandlerType
	) {
		self.loggerInfo = loggerInfo
		self.logHandler = logHandler
	}
}



extension DefaultLogger: Logger {
	func trace (_ message: @autoclosure () -> LogHandlerType.Message, source: @autoclosure () -> [String]) {
		log(level: .trace, message: message(), source: source())
	}
	
	func debug (_ message: @autoclosure () -> LogHandlerType.Message, source: @autoclosure () -> [String]) {
		log(level: .trace, message: message(), source: source())
	}
	
	func info (_ message: @autoclosure () -> LogHandlerType.Message, source: @autoclosure () -> [String]) {
		log(level: .trace, message: message(), source: source())
	}
	
	func notice (_ message: @autoclosure () -> LogHandlerType.Message, source: @autoclosure () -> [String]) {
		log(level: .trace, message: message(), source: source())
	}
	
	func warning (_ message: @autoclosure () -> LogHandlerType.Message, source: @autoclosure () -> [String]) {
		log(level: .trace, message: message(), source: source())
	}
	
	func fault (_ message: @autoclosure () -> LogHandlerType.Message, source: @autoclosure () -> [String]) {
		log(level: .trace, message: message(), source: source())
	}
	
	func error (_ message: @autoclosure () -> LogHandlerType.Message, source: @autoclosure () -> [String]) {
		log(level: .trace, message: message(), source: source())
	}
	
	func critical (_ message: @autoclosure () -> LogHandlerType.Message, source: @autoclosure () -> [String]) {
		log(level: .trace, message: message(), source: source())
	}
}



extension DefaultLogger: LogHandler {
	func log (level: LoggingLevel, message: @autoclosure () -> LogHandlerType.Message, source: @autoclosure () -> [String]) {
		guard level >= loggerInfo.level else { return }
		
		let source = loggerInfo.source + source()
		
		logHandler.log(level: level, message: message(), source: source)
	}
}
