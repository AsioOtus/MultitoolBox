public extension DefaultLogHandler {
	struct Settings {
		public let prefix: String
		public let source: String
		public let loggingProvider: LoggingProvider
		
		public var level = LogLevel.info
		public var enableSourceCodeInfo = false
		
		public init (prefix: String, source: String = "", loggingProvider: LoggingProvider, level: LogLevel = .info, enableSourceCodeInfo: Bool = false) {
			self.prefix = prefix
			self.source = source
			self.loggingProvider = loggingProvider
			
			self.level = level
			self.enableSourceCodeInfo = enableSourceCodeInfo
		}
	}
}

public class DefaultLogHandler: LogHandler {
	public var settings: Settings
	
	public init (settings: Settings) {
		self.settings = settings
	}
	
	private func message (_ level: LogLevel, source: String = "", message: String) -> String {
		func delimiter (_ message: String, _ delimiter: String) -> String { !message.isEmpty ? delimiter : "" }
		
		var finalMessage = "\(level) – ".uppercased()
		
		if !settings.prefix.isEmpty {
			finalMessage += settings.prefix
		}
		
		if !settings.source.isEmpty {
			finalMessage += delimiter(finalMessage, ".") + settings.source
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
		guard level >= settings.level else { return }
		
		let finalMessage = self.message(level, source: source, message: message)
		
		settings.loggingProvider.log(level, finalMessage)
	}
}
