public extension DefaultLogHandler {
	struct Settings {
		public let prefix: String
		public let source: String
		public let logExporter: LogExporter
		
		public var level = LoggingLevel.info
		public var enableSourceCodeInfo = false
		public var componentsSeparator = " | "
		
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
		let message1 = [level.padded, settings.prefix].combine(with: settings.componentsSeparator)
		let message2 = [message1, settings.source, source].combine()
		let finalMessage = [message2, message].combine(with: settings.componentsSeparator)
		return finalMessage
	}
	
	public func log(level: LoggingLevel, message: @autoclosure () -> String, source: @autoclosure () -> String?, file: String, function: String, line: UInt) {
		guard level >= settings.level else { return }
		
		let finalMessage = self.message(level, source: source() ?? "", message: message())
		
		settings.logExporter.log(level, finalMessage)
	}
}
