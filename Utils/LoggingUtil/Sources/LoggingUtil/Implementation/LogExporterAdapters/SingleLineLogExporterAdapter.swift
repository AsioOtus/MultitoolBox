public extension SingleLineLogExporterAdapter {
	struct Configuration {
		public var metaInfoEnabling: MetaInfo.Enabling
		public var detailsEnabling: StandardLogRecordDetails.Enabling
		public var levelPadding: Bool
		public var componentsSeparator: String
		
		public init (
			metaInfoEnabling: MetaInfo.Enabling = .enabled(),
			detailsEnabling: StandardLogRecordDetails.Enabling = .enabled(),
			levelPadding: Bool = true,
			componentsSeparator: String = " | "
		) {
			self.metaInfoEnabling = metaInfoEnabling
			self.detailsEnabling = detailsEnabling
			self.levelPadding = levelPadding
			self.componentsSeparator = componentsSeparator
		}
	}
}

public struct SingleLineLogExporterAdapter <LogExporterType: LogExporter>: StringLogExporterAdapter where LogExporterType.Message == String {
	public var logExporter: LogExporterType
	public var configuration: Configuration
	
	public init (logExporter: LogExporterType, configuration: Configuration = .init()) {
		self.logExporter = logExporter
		self.configuration = configuration
	}
	
	public func adapt (logRecord: LogRecord<String, StandardLogRecordDetails>) {
		let logRecordDetails = logRecord.details?.moderated(configuration.detailsEnabling)
		
		var messageComponents = [String]()
		
		if case let .enabled(_, level: isLevelEnabled, _) = configuration.metaInfoEnabling, isLevelEnabled {
			messageComponents.append(configuration.levelPadding
				? logRecord.metaInfo.level.logDescription.padding(toLength: LogLevel.critical.logDescription.count, withPad: " ", startingAt: 0)
				: logRecord.metaInfo.level.logDescription
			)
		}
		
		if let tags = logRecordDetails?.tags, !tags.isEmpty {
			messageComponents.append("[\(tags.sorted(by: <).joined(separator: ", "))]")
		}
		
		if let source = logRecordDetails?.source, !source.isEmpty {
			messageComponents.append(source.combine(with: "."))
		}
		
		messageComponents.append(logRecord.message)
		
		if let keyValue = logRecordDetails?.keyValue, !keyValue.isEmpty {
			messageComponents.append("\(keyValue)")
		}
		
		if let comment = logRecordDetails?.comment, !comment.isEmpty {
			messageComponents.append(comment)
		}
		
		let finalMessage = messageComponents.combine(with: configuration.componentsSeparator)
		
		logExporter.log(metaInfo: logRecord.metaInfo, message: finalMessage)
	}
}



fileprivate extension LogLevel {
	var logDescription: String { self.rawValue.uppercased() }
}



fileprivate extension Array where Element == String {
	func combine (with separator: String) -> String {
		let preparedSources = self.compactMap{ $0 }.filter { !$0.isEmpty }
		return preparedSources.joined(separator: separator)
	}
}
