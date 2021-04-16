public class MultiplexLogHandler<InnerLogHandler: EnhancedLogHandler> {
	public var logHandlers: [InnerLogHandler]
	public var loggerInfo: EnhancedLoggerInfo
	public var enabling: EnhancedEnablingConfig
	
	public init (
		logHandlers: [InnerLogHandler],
		loggerInfo: EnhancedLoggerInfo = .init(),
		enabling: EnhancedEnablingConfig = .init()
	) {
		self.logHandlers = logHandlers
		self.loggerInfo = loggerInfo
		self.enabling = enabling
	}
}

extension MultiplexLogHandler: EnhancedLogHandler {
	public typealias Message = InnerLogHandler.Message
	
	public func log (metaInfo: EnhancedMetaInfo, logRecord: EnhancedLogRecord<Message>) {
		guard metaInfo.level >= loggerInfo.level else { return }
		
		let metaInfo = EnhancedMetaInfo(timestamp: metaInfo.timestamp, level: metaInfo.level, labels: [loggerInfo.label] + metaInfo.labels)
		let logRecord = EnhancedLogRecordCombiner.default.combine(logRecord, loggerInfo)
		let moderatedLogRecord = EnhancedModerator.default.moderate(logRecord: logRecord, enabling: enabling)
		
		for logHandler in logHandlers {
			logHandler.log(metaInfo: metaInfo, logRecord: moderatedLogRecord)
		}
	}
}
