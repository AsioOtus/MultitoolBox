public class StandardEnhancedLogHandler {
	public typealias Message = String
	
	public var logRecordAdapter: StringLogRecordAdapter
	public var loggerInfo: EnhancedLoggerInfo
	public var enabling: EnhancedEnablingConfig
	
	public init (
		logRecordAdapter: StringLogRecordAdapter,
		loggerInfo: EnhancedLoggerInfo = .init(),
		enabling: EnhancedEnablingConfig = .init()
	) {
		self.logRecordAdapter = logRecordAdapter
		self.loggerInfo = loggerInfo
		self.enabling = enabling
	}
}



extension StandardEnhancedLogHandler: EnhancedLogHandler {
	public func log (metaInfo: EnhancedMetaInfo, logRecord: EnhancedLogRecord<Message>) {
		guard metaInfo.level >= loggerInfo.level else { return }
		
		let metaInfo = EnhancedMetaInfo(timestamp: metaInfo.timestamp, level: metaInfo.level, labels: [loggerInfo.label] + metaInfo.labels)
		let logRecord = EnhancedLogRecordCombiner.default.combine(logRecord, loggerInfo)
		let moderatedLogRecord = EnhancedModerator.default.moderate(logRecord: logRecord, enabling: enabling)
		
		logRecordAdapter.adapt(metaInfo: metaInfo, logRecord: moderatedLogRecord)
	}
}
