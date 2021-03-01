public class DefaultLogHandler<LogExporter: StringLogExporter>: LogHandler {
	public typealias Message = String
	public typealias Configuration = LogExporter.Configuration
	
	public var sourcePrefix: String
	public var levelPadding: Bool
	public var componentsSeparator: String
	public var loggerInfo: LoggerInfo
	public var enabling: EnablingConfiguration
	public var stringLogExporter: LogExporter
	public var logExporterConfiguration: Configuration?
	
	public init (
		sourcePrefix: String,
		levelPadding: Bool = false,
		componentsSeparator: String = " | ",
		loggerInfo: LoggerInfo = .init(),
		enabling: EnablingConfiguration = .init(),
		stringLogExporter: LogExporter,
		logExporterConfiguration: Configuration? = nil
	) {
		self.sourcePrefix = sourcePrefix
		self.levelPadding = levelPadding
		self.componentsSeparator = componentsSeparator
		self.loggerInfo = loggerInfo
		self.enabling = enabling
		self.stringLogExporter = stringLogExporter
		self.logExporterConfiguration = logExporterConfiguration
	}
	
	private func message (from logRecord: LogRecord<Message>) -> String {
		var messageComponents = [String]()
		
		if let level = logRecord.level {
			messageComponents.append(levelPadding
				? level.description.padding(toLength: LoggingLevel.critical.description.count, withPad: " ", startingAt: 0)
				: level.description
			)
		}
		
		if let tags = logRecord.tags, !tags.isEmpty {
			messageComponents.append("[\(loggerInfo.tags.union(tags).sorted(by: <).joined(separator: ", "))]")
		}
		
		if let source = logRecord.source, !source.isEmpty {
			messageComponents.append(([sourcePrefix] + loggerInfo.source + source).combine())
		}
		
		messageComponents.append(logRecord.message)
		
		if let details = logRecord.details, !details.isEmpty {
			messageComponents.append("\(loggerInfo.details.merging(details, uniquingKeysWith: { _, detail in detail }))")
		}
		
		if let comment = logRecord.comment, !comment.isEmpty {
			messageComponents.append("\(!comment.isEmpty ? comment : loggerInfo.comment)")
		}
		
		let finalMessage = messageComponents.combine(with: componentsSeparator)
		
		return finalMessage
	}
	
	public func log (
		level: LoggingLevel,
		message: @autoclosure () -> Message,
		source: @autoclosure () -> [String],
		tags: @autoclosure () -> Set<String>,
		details: @autoclosure () -> [String: Any],
		comment: @autoclosure () -> String,
		file: String, function: String, line: UInt,
		logHandlerConfiguration: Configuration?
	) {
		guard level >= loggerInfo.level else { return }
		
		let logExporterConfiguration = logHandlerConfiguration ?? self.logExporterConfiguration
		
		let logRecord = Moderator.default.moderate(
			logRecord:
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
				),
			enabling: enabling
		)
		
		let finalMessage = self.message(from: logRecord)
		
		stringLogExporter.log(level, finalMessage, logExporterConfiguration)
	}
}
