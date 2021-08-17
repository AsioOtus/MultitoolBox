public class StandardLogHandler {
	public typealias Message = String
	public typealias Details = StandardLogRecordDetails
	
	public var isEnabled = true
	public var level = LogLevel.trace
	public var details: Details? = nil
	public var logExporterAdapter: StringLogExporterAdapter
	public let label: String
	
	public init (
		logExporterAdapter: StringLogExporterAdapter,
		label: String = "\(StandardLogHandler.self):\(#file):\(#line)"
	) {
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

extension StandardLogHandler {
	func isEnabled (_ isEnabled: Bool) -> Self {
		self.isEnabled = isEnabled
		return self
	}
	
	func level (_ level: LogLevel) -> Self {
		self.level = level
		return self
	}
	
	func details (_ details: Details) -> Self {
		self.details = details
		return self
	}
}
