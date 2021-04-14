public extension StandardEnhancedLogHandler {
	struct Configuration {
		public var sourcePrefix: String
		public var levelPadding: Bool
		public var componentsSeparator: String
		public var enabling: EnhancedEnablingConfig
		public var logExporterConfiguration: LogExporter.Configuration?
		
		public init (
			sourcePrefix: String = "",
			levelPadding: Bool = true,
			componentsSeparator: String = " | ",
			enabling: EnhancedEnablingConfig = .init(),
			logExporterConfiguration: LogExporter.Configuration? = nil
		) {
			self.sourcePrefix = sourcePrefix
			self.levelPadding = levelPadding
			self.componentsSeparator = componentsSeparator
			self.enabling = enabling
			self.logExporterConfiguration = logExporterConfiguration
		}
	}
}



public class StandardEnhancedLogHandler<LogExporter: StringLogExporter> {
	public typealias Message = String
	
	public var configuration: Configuration
	public var loggerInfo: EnhancedLoggerInfo
	public var stringLogExporter: LogExporter
	
	public init (
		configuration: Configuration,
		loggerInfo: EnhancedLoggerInfo = .init(),
		stringLogExporter: LogExporter
	) {
		self.configuration = configuration
		self.loggerInfo = loggerInfo
		self.stringLogExporter = stringLogExporter
	}
	
	private func message (from logRecord: EnhancedLogRecord<Message>) -> String {
		var messageComponents = [String]()
		
		if let level = logRecord.level {
			messageComponents.append(configuration.levelPadding
				? level.logDescription.padding(toLength: LoggingLevel.critical.logDescription.count, withPad: " ", startingAt: 0)
				: level.logDescription
			)
		}
		
		if let tags = logRecord.tags, !tags.isEmpty {
			messageComponents.append("[\(loggerInfo.tags.union(tags).sorted(by: <).joined(separator: ", "))]")
		}
		
		if let source = logRecord.source, !source.isEmpty {
			messageComponents.append(([configuration.sourcePrefix] + loggerInfo.source + source).combine())
		}
		
		messageComponents.append(logRecord.message)
		
		if let details = logRecord.details, !details.isEmpty {
			messageComponents.append("\(loggerInfo.details.merging(details, uniquingKeysWith: { _, detail in detail }))")
		}
		
		if let comment = logRecord.comment, !comment.isEmpty {
			messageComponents.append("\(!comment.isEmpty ? comment : loggerInfo.comment)")
		}
		
		let finalMessage = messageComponents.combine(with: configuration.componentsSeparator)
		
		return finalMessage
	}
}


extension StandardEnhancedLogHandler: EnhancedLogHandler {
	public func log (level: LoggingLevel, logRecord: LogRecord<String>) {
		guard level >= loggerInfo.level else { return }
		
		let source = logRecord.source ?? []
		
		let logRecord = EnhancedLogRecord(
			level: logRecord.level,
			message: logRecord.message,
			source: [configuration.sourcePrefix] + loggerInfo.source + source,
			tags: loggerInfo.tags,
			details: loggerInfo.details,
			comment: loggerInfo.comment,
			labels: [loggerInfo.label]
		)
		
		let moderatedLogRecord = EnhancedModerator.default.moderate(
			logRecord: logRecord,
			enabling: configuration.enabling
		)
		
		let finalMessage = self.message(from: moderatedLogRecord)
		stringLogExporter.log(level, finalMessage, configuration.logExporterConfiguration)
	}
	
	public func log (level: LoggingLevel, logRecord: EnhancedLogRecord<String>, configuration: Configuration?) {
		guard level >= loggerInfo.level else { return }
		
		let configuration = configuration ?? self.configuration
		
		let logRecord = EnhancedLogRecordCombiner.default.combine(logRecord, loggerInfo, configuration.sourcePrefix)
		
		let moderatedLogRecord = EnhancedModerator.default.moderate(
			logRecord: logRecord,
			enabling: configuration.enabling
		)
		
		let finalMessage = self.message(from: moderatedLogRecord)
		stringLogExporter.log(level, finalMessage, configuration.logExporterConfiguration)
	}
}



fileprivate extension LoggingLevel {
	var logDescription: String { self.rawValue.uppercased() }
}



fileprivate extension Array where Element == String {
	func combine (with separator: String = ".") -> String {
		let preparedSources = self.compactMap{ $0 }.filter { !$0.isEmpty }
		return preparedSources.joined(separator: separator)
	}
}
