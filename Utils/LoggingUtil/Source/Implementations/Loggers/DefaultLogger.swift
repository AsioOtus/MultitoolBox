struct DefaultLogger<LogHandlerType: LoggingUtil.LogHandler> {
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
		guard level >= level else { return }
		
		let source = self.source + source()
		
		logHandler.log(level: level, message: message(), source: source)
	}
}
