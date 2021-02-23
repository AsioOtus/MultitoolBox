public class DefaultLogHandler: LogHandler {
	public var sourcePrefix: String
	public var levelPadding: Bool
	public var componentsSeparator: String
	public var stringLogExporter: StringLogExporter
	public var loggerInfo: LoggerInfo
	public var enabling: EnablingConfiguration
	
	public init (
		sourcePrefix: String,
		levelPadding: Bool = false,
		componentsSeparator: String = " | ",
		stringLogExporter: StringLogExporter,
		loggerInfo: LoggerInfo = .init(),
		enabling: EnablingConfiguration = .init()
	) {
		self.sourcePrefix = sourcePrefix
		self.stringLogExporter = stringLogExporter
		self.componentsSeparator = componentsSeparator
		self.levelPadding = levelPadding
		self.loggerInfo = loggerInfo
		self.enabling = enabling
	}
	
	private func moderate (logRecord: LogRecord) -> LogRecord {
		.init(
			level: enabling.level ? logRecord.level : nil,
			message: logRecord.message,
			source: enabling.source ? logRecord.source : nil,
			tags: enabling.tags ? logRecord.tags : nil,
			details: enabling.details ? logRecord.details : nil,
			comment: enabling.comment ? logRecord.comment : nil,
			file: enabling.codeInfo ? logRecord.file : nil,
			function: enabling.codeInfo ? logRecord.function : nil,
			line: enabling.codeInfo ? logRecord.line : nil
		)
	}
	
	private func message (from logRecord: LogRecord) -> String {
		var messageComponents = [String]()
		
		if let level = logRecord.level {
			messageComponents.append(levelPadding
				? level.description.padding(toLength: LoggingLevel.critical.description.count, withPad: " ", startingAt: 0)
				: level.description
			)
		}
		
		if let tags = logRecord.tags {
			messageComponents.append("[\(loggerInfo.tags.union(tags).sorted(by: <).joined(separator: ", "))]")
		}
		
		if let source = logRecord.source {
			messageComponents.append(([sourcePrefix] + loggerInfo.source + source).combine())
		}
		
		messageComponents.append(logRecord.message)
		
		if let details = logRecord.details {
			messageComponents.append("\(loggerInfo.details.merging(details, uniquingKeysWith: { _, detail in detail }))")
		}
		
		if let comment = logRecord.comment {
			messageComponents.append("\(!comment.isEmpty ? comment : loggerInfo.comment)")
		}
		
		let finalMessage = messageComponents.combine(with: componentsSeparator)
		
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
		guard level >= loggerInfo.level else { return }
		
		let logRecord = moderate(logRecord:
			.init(
				level: level,
				message: message(),
				source: source(),
				tags: tags(),
				details: details(),
				comment: comment(),
				file: file,
				function: function,
				line: line
			)
		)
		
		let finalMessage = self.message(from: logRecord)
		
		stringLogExporter.log(level, finalMessage)
	}
}
