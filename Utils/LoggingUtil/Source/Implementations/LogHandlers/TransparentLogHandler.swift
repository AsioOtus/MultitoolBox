public class TransparentLogHandler<InnerLogHandler: EnhancedLogHandler> {
	public typealias Message = InnerLogHandler.Message
	
	public var innerLogHandler: InnerLogHandler
	public var loggerInfo: EnhancedLoggerInfo
	public var enabling: EnhancedEnablingConfig
	
	public init (
		innerLogHandler: InnerLogHandler,
		loggerInfo: EnhancedLoggerInfo = .init(),
		enabling: EnhancedEnablingConfig = .init()
	) {
		self.innerLogHandler = innerLogHandler
		self.loggerInfo = loggerInfo
		self.enabling = enabling
	}
}



extension TransparentLogHandler: EnhancedLogHandler {
	public func log (metaInfo: EnhancedMetaInfo, logRecord: EnhancedLogRecord<Message>) {
		guard metaInfo.level >= loggerInfo.level else { return }
		
		let metaInfo = EnhancedMetaInfo(timestamp: metaInfo.timestamp, level: metaInfo.level, labels: [loggerInfo.label] + metaInfo.labels)
		let logRecord = EnhancedLogRecordCombiner.default.combine(logRecord, loggerInfo)
		let moderatedLogRecord = EnhancedLogRecordModerator.default.moderate(logRecord: logRecord, enabling: enabling)
		
		innerLogHandler.log(metaInfo: metaInfo, logRecord: moderatedLogRecord)
	}
}
