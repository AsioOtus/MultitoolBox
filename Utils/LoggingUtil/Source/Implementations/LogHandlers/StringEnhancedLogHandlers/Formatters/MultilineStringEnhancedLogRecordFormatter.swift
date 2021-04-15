
public extension MultilineFormatter {
	struct Configuration {
		public static let defaultDateFormatter: DateFormatter = {
			let formatter = DateFormatter()
			formatter.dateStyle = .short
			return formatter
		}()
		
		public var levelPadding: Bool
		public var componentsSeparator: String
		public var dateFormatter: DateFormatter
		
		public init (
			levelPadding: Bool = true,
			componentsSeparator: String = " | ",
			dateFormatter: DateFormatter = defaultDateFormatter
		) {
			self.levelPadding = levelPadding
			self.componentsSeparator = componentsSeparator
			self.dateFormatter = dateFormatter
		}
	}
}

public struct MultilineFormatter: StringLogRecordFormatted {
	public var configuration: Configuration
	
	public init (configuration: Configuration = .init()) {
		self.configuration = configuration
	}
	
	public func format (logRecord: EnhancedLogRecord<String>) -> String {
		var messageHeaderComponents = [String]()
		
		if let timestamp = logRecord.timestamp {
			let formattedDate = configuration.dateFormatter.string(from: Date(timeIntervalSince1970: timestamp))
			messageHeaderComponents.append(formattedDate)
		}
		
		if let level = logRecord.level {
			messageHeaderComponents.append(configuration.levelPadding
										? level.logDescription.padding(toLength: LoggingLevel.critical.logDescription.count, withPad: " ", startingAt: 0)
										: level.logDescription
			)
		}
		
		if let tags = logRecord.tags, !tags.isEmpty {
			messageHeaderComponents.append("[\(tags.sorted(by: <).joined(separator: ", "))]")
		}
		
		if let source = logRecord.source, !source.isEmpty {
			messageHeaderComponents.append(source.combine(with: "."))
		}
		
		let messageHeader = messageHeaderComponents.combine(with: configuration.componentsSeparator)
		
		var messageComponents = [String]()
		
		messageComponents.append(messageHeader)
		messageComponents.append(logRecord.message)
		
		if let details = logRecord.details, !details.isEmpty {
			messageComponents.append("\(details)")
		}
		
		if let comment = logRecord.comment, !comment.isEmpty {
			messageComponents.append(comment)
		}
		
		messageComponents.append("\n")
		
		let finalMessage = messageComponents.combine(with: "\n")
		
		return finalMessage
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
