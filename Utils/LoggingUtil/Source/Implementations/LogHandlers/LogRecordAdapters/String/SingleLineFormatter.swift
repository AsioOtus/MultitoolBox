public extension SingleLineFormatter {
	struct Configuration {
		public var levelPadding: Bool
		public var componentsSeparator: String
		
		public init (
			levelPadding: Bool = true,
			componentsSeparator: String = " | "
		) {
			self.levelPadding = levelPadding
			self.componentsSeparator = componentsSeparator
		}
	}
}

public struct SingleLineFormatter <LogExporterType: LogExporter>: StringLogRecordAdapter where LogExporterType.Message == String {
	public var logExporter: LogExporterType
	public var configuration: Configuration
	
	public init (logExporter: LogExporterType, configuration: Configuration = .init()) {
		self.logExporter = logExporter
		self.configuration = configuration
	}
	
	public func adapt (metaInfo: EnhancedMetaInfo, logRecord: EnhancedLogRecord<String>) {
		var messageComponents = [String]()
		
		if let level = logRecord.level {
			messageComponents.append(configuration.levelPadding
				? level.logDescription.padding(toLength: LoggingLevel.critical.logDescription.count, withPad: " ", startingAt: 0)
				: level.logDescription
			)
		}
		
		if let tags = logRecord.tags, !tags.isEmpty {
			messageComponents.append("[\(tags.sorted(by: <).joined(separator: ", "))]")
		}
		
		if let source = logRecord.source, !source.isEmpty {
			messageComponents.append(source.combine(with: "."))
		}
		
		messageComponents.append(logRecord.message)
		
		if let details = logRecord.details, !details.isEmpty {
			messageComponents.append("\(details)")
		}
		
		if let comment = logRecord.comment, !comment.isEmpty {
			messageComponents.append(comment)
		}
		
		let finalMessage = messageComponents.combine(with: configuration.componentsSeparator)
		
		logExporter.log(metaInfo: metaInfo, message: finalMessage, configuration: nil)
	}
}



fileprivate extension LoggingLevel {
	var logDescription: String { self.rawValue.uppercased() }
}



fileprivate extension Array where Element == String {
	func combine (with separator: String) -> String {
		let preparedSources = self.compactMap{ $0 }.filter { !$0.isEmpty }
		return preparedSources.joined(separator: separator)
	}
}
