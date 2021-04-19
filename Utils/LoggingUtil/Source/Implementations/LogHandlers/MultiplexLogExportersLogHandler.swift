public class MultiplexLogExportersLogHandler {
	public var logRecordAdapters: [StringLogRecordAdapter]
	public var loggerInfo: EnhancedLoggerInfo
	public var enabling: EnhancedEnablingConfig
	
	public init (
		logRecordAdapters: [StringLogRecordAdapter],
		loggerInfo: EnhancedLoggerInfo = .init(),
		enabling: EnhancedEnablingConfig = .init()
	) {
		self.logRecordAdapters = logRecordAdapters
		self.loggerInfo = loggerInfo
		self.enabling = enabling
	}
}



extension MultiplexLogExportersLogHandler: EnhancedLogHandler {
	public typealias Message = String
	
	public func log (metaInfo: EnhancedMetaInfo, logRecord: EnhancedLogRecord<Message>) {
		guard metaInfo.level >= loggerInfo.level else { return }
		
		let metaInfo = EnhancedMetaInfo(timestamp: metaInfo.timestamp, level: metaInfo.level, labels: [loggerInfo.label] + metaInfo.labels)
		let logRecord = EnhancedLogRecordCombiner.default.combine(logRecord, loggerInfo)
		let moderatedLogRecord = EnhancedModerator.default.moderate(logRecord: logRecord, enabling: enabling)
		
		for logAdapter in logRecordAdapters {
			logAdapter.adapt(metaInfo: metaInfo, logRecord: moderatedLogRecord)
		}
	}
}
