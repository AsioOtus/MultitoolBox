public extension DefaultEnhancedLogHandler {
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



public class DefaultEnhancedLogHandler<LogExporter: StringLogExporter> {
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


extension DefaultEnhancedLogHandler: EnhancedLogHandler {
	public func log (level: LoggingLevel, message: @autoclosure () -> String, source: @autoclosure () -> [String]) {
		guard level >= loggerInfo.level else { return }
		
		let source = loggerInfo.source + source()
		let tags = loggerInfo.tags
		let details = loggerInfo.details
		let comment = loggerInfo.comment
		let configuration = self.configuration
		
		let logRecord = EnhancedModerator.default.moderate(
			logRecord:
				.init(
					level: level,
					message: message(),
					source: source,
					tags: tags,
					details: details,
					comment: comment,
					file: "",
					function: "",
					line: 0
				),
			enabling: configuration.enabling
		)
		
		let finalMessage = self.message(from: logRecord)
		
		stringLogExporter.log(level, finalMessage, configuration.logExporterConfiguration)
	}
	
	public func log (
		level: LoggingLevel,
		message: @autoclosure () -> Message,
		source: @autoclosure () -> [String],
		tags: @autoclosure () -> Set<String>,
		details: @autoclosure () -> [String: Any],
		comment: @autoclosure () -> String,
		file: String, function: String, line: UInt,
		logHandlerConfiguration: Configuration?,
		labels: [String]
	) {
		guard level >= loggerInfo.level else { return }
		
		let source = loggerInfo.source + source()
		let tags = loggerInfo.tags.union(tags())
		let details = loggerInfo.details.merging(details(), uniquingKeysWith: { _, detail in detail })
		let comment = !comment().isEmpty ? comment() : loggerInfo.comment
		let configuration = logHandlerConfiguration ?? self.configuration
		
		let logRecord = EnhancedModerator.default.moderate(
			logRecord:
				.init(
					level: level,
					message: message(),
					source: source,
					tags: tags,
					details: details,
					comment: comment,
					file: file,
					function: function,
					line: line
				),
			enabling: configuration.enabling
		)
		
		let finalMessage = self.message(from: logRecord)
		
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
