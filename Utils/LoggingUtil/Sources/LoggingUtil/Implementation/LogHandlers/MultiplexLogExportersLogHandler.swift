public class MultiplexLogExportersLogHandler {
	public typealias Message = String
	public typealias Details = StandardLogRecordDetails
	
	public let label: String
	public var isEnabled: Bool
	public var level: LogLevel
	public var logExporterAdapters: [StringLogExporterAdapter]
	public var details: Details?
	
	public init (
		isEnabled: Bool = true,
		level: LogLevel,
		logExporterAdapters: [StringLogExporterAdapter],
		details: Details? = nil,
		label: String = "\(StandardEnhancedLogHandler.self):\(#file):\(#line)"
	) {
		self.label = label
		self.isEnabled = isEnabled
		self.level = level
		self.logExporterAdapters = logExporterAdapters
		self.details = details
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

