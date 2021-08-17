public class MultiplexLogExportersLogHandler {
	public typealias Message = String
	public typealias Details = StandardLogRecordDetails
	
	public var isEnabled = true
	public var level = LogLevel.trace
	public var details: Details? = nil
	public var logExporterAdapters: [StringLogExporterAdapter]
	public let label: String
	
	public init (
		logExporterAdapters: [StringLogExporterAdapter],
		label: String = "\(MultiplexLogExportersLogHandler.self):\(#file):\(#line)"
	) {
		self.logExporterAdapters = logExporterAdapters
		self.label = label
	}
}

extension MultiplexLogExportersLogHandler: LogHandler {
	public func log (logRecord: LogRecord<Message, Details>) {
		guard isEnabled, logRecord.metaInfo.level >= level else { return }
		
		let metaInfo = logRecord.metaInfo.add(label: label)
		let details = logRecord.details?.combined(with: self.details)
		let logRecord = logRecord.replace(metaInfo, details)
		
		logExporterAdapters.forEach{ $0.adapt(logRecord: logRecord) }
	}
}

extension MultiplexLogExportersLogHandler {
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
