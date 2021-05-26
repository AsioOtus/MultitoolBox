public class StandardLogHandler {
	public typealias Message = String
	public typealias Details = StandardLogRecordDetails
	
	public var isEnabled: Bool
	public var level: LogLevel
	public var details: Details?
	public var logExporterAdapter: StringLogExporterAdapter
	public let label: String
	
	public init (
		isEnabled: Bool = true,
		level: LogLevel = .trace,
		details: Details? = nil,
		logExporterAdapter: StringLogExporterAdapter,
		label: String = "\(StandardLogHandler.self):\(#file):\(#line)"
	) {
		self.isEnabled = isEnabled
		self.level = level
		self.details = details
		self.logExporterAdapter = logExporterAdapter
		self.label = label
	}
}



extension StandardLogHandler: LogHandler {
	public func log (logRecord: LogRecord<Message, Details>) {
		guard isEnabled, logRecord.metaInfo.level >= level else { return }
		
		let metaInfo = logRecord.metaInfo.add(label: label)
		let details = logRecord.details?.combined(with: self.details)
		let logRecord = logRecord.replace(metaInfo, details)
		
		logExporterAdapter.adapt(logRecord: logRecord)
	}
}
