public class MultiplexLogExportersLogHandler {
	public typealias Message = String
	public typealias Details = StandardLogRecordDetails
	
	public var isEnabled: Bool
	public var level: LogLevel
	public var details: Details?
	public var logExporterAdapters: [StringLogExporterAdapter]
	public let label: String
	
	public init (
		isEnabled: Bool = true,
		level: LogLevel,
		details: Details? = nil,
		logExporterAdapters: [StringLogExporterAdapter],
		label: String = "\(MultiplexLogExportersLogHandler.self):\(#file):\(#line)"
	) {
		self.isEnabled = isEnabled
		self.level = level
		self.details = details
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

