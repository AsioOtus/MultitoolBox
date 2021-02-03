public extension DefaultLogHandler {
	struct Settings {
		public let prefix: String
		public let source: String
		public let logExporter: LogExporter
		
		public var level = LoggingLevel.info
		public var enableSourceCodeInfo = false
		
		public init (prefix: String, source: String = "", level: LoggingLevel = .info, enableSourceCodeInfo: Bool = false, logExporter: LogExporter) {
			self.prefix = prefix
			self.source = source
			self.logExporter = logExporter
			
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
	
	private func message (_ level: LoggingLevel, source: String = "", message: String) -> String {
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
	
	public func log(level: LoggingLevel, message: @autoclosure () -> String, source: @autoclosure () -> String?, file: String, function: String, line: UInt) {
		guard level >= settings.level else { return }
		
		let finalMessage = self.message(level, source: source() ?? "", message: message())
		
		settings.logExporter.log(level, finalMessage)
	}
}
