public class StandardEnhancedLogHandler {
	public typealias Message = String
	public typealias Details = StandardLogRecordDetails
	
	public let label: String
	public var isEnabled: Bool
	public var level: LogLevel
	public var logExporterAdapter: StringLogExporterAdapter
	public var details: Details?
	
	public init (
		isEnabled: Bool = true,
		level: LogLevel,
		logExporterAdapter: StringLogExporterAdapter,
		details: Details? = nil,
		label: String = "\(StandardEnhancedLogHandler.self):\(#file):\(#line)"
	) {
		self.label = label
		self.isEnabled = isEnabled
		self.level = level
		self.logExporterAdapter = logExporterAdapter
		self.details = details
	}
}



extension StandardEnhancedLogHandler: LogHandler {
	public func log (logRecord: LogRecord<Message, Details>) {
		guard isEnabled, logRecord.metaInfo.level >= level else { return }
		
		let metaInfo = logRecord.metaInfo.add(label: label)
		let details = logRecord.details?.combined(with: self.details)
		let logRecord = logRecord.replace(metaInfo, details)
		
		logExporterAdapter.adapt(logRecord: logRecord)
	}
}
