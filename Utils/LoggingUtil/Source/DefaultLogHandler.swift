import os

public extension DefaultLogHandler {
	struct Settings {
		public var level = LogLevel.info
		public var enableSourceCodeInfo = false
		
		public init (level: LogLevel = .info, enableSourceCodeInfo: Bool = false) {
			self.level = level
			self.enableSourceCodeInfo = enableSourceCodeInfo
		}
	}
}

public class DefaultLogHandler: LogHandler {
	private let logger = os.Logger()
	
	public let prefix: String
	public let source: String
	
	public var settings = Settings()
	
	public init (prefix: String, source: String = "", settings: Settings = .init()) {
		self.prefix = prefix
		self.source = source
		self.settings = settings
	}
	
	private func message (_ level: LogLevel, source: String = "", message: String) -> String {
		func delimiter (_ message: String, _ delimiter: String) -> String { !message.isEmpty ? delimiter : "" }
		
		var finalMessage = "\(level) – ".uppercased()
		
		if !prefix.isEmpty {
			finalMessage += prefix
		}
		
		if !self.source.isEmpty {
			finalMessage += delimiter(finalMessage, ".") + self.source
		}
		
		if !source.isEmpty {
			finalMessage += delimiter(finalMessage, ".") + source
		}
		
		if !message.isEmpty {
			finalMessage += delimiter(finalMessage, " – ") + message
		}
		
		return finalMessage
	}
	
	public func log (_ level: LogLevel, _ source: String, _ message: String, _ file: String, _ function: String, _ line: UInt) {
		let finalMessage = self.message(level, source: source, message: message)
		
		switch level {
		case .trace:
			logger.trace("\(finalMessage)")
		case .debug:
			logger.debug("\(finalMessage)")
		case .info:
			logger.info("\(finalMessage)")
		case .notice:
			logger.notice("\(finalMessage)")
		case .warning:
			logger.warning("\(finalMessage)")
		case .error:
			logger.error("\(finalMessage)")
		case .critical:
			logger.critical("\(finalMessage)")
		case .fault:
			logger.fault("\(finalMessage)")
		}
	}
}
