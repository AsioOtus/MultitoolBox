public class DefaultLogHandler: LogHandler {
	public var level: LoggingLevel
	public let prefix: String
	public let source: [String]
	public var tags: Set<String>
	public var details: [String: Any]
	public var comment: String
	public let logExporter: LogExporter
	public var componentsSeparator: String
	
	public init (
		level: LoggingLevel = .info,
		prefix: String,
		source: [String] = [],
		tags: Set<String> = [],
		details: [String : Any] = [:],
		comment: String = "",
		logExporter: LogExporter,
		componentsSeparator: String = " | "
	) {
		self.level = level
		self.prefix = prefix
		self.source = source
		self.tags = tags
		self.details = details
		self.comment = comment
		self.logExporter = logExporter
		self.componentsSeparator = componentsSeparator
	}
	
	private func message (_ level: LoggingLevel, source: [String], message: String) -> String {
		let source = ([prefix] + self.source + source).combine()
		let finalMessage = [level.padded, source, message].combine(with: componentsSeparator)
		return finalMessage
	}
	
	public func log (
		level: LoggingLevel,
		message: @autoclosure () -> String,
		source: @autoclosure () -> [String],
		tags: @autoclosure () -> Set<String>,
		details: @autoclosure () -> [String: Any],
		comment: @autoclosure () -> String,
		file: String, function: String, line: UInt
	) {
		guard level >= self.level else { return }
		
		let finalMessage = self.message(level, source: source(), message: message())
		
		logExporter.log(level, finalMessage)
	}
}
