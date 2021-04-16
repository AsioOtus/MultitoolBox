public protocol EnhancedLogHandler: LogHandler {
	var loggerInfo: EnhancedLoggerInfo { get set }
	
	func log (
		metaInfo: EnhancedMetaInfo,
		logRecord: EnhancedLogRecord<Message>
	)
}

public extension EnhancedLogHandler {
	func log (metaInfo: MetaInfo, logRecord: LogRecord<Message>) {
		let metaInfo = EnhancedMetaInfo(timestamp: metaInfo.timestamp, level: metaInfo.level, labels: [])
		
		let logRecord = EnhancedLogRecord(
			level: logRecord.level,
			message: logRecord.message,
			source: logRecord.source
		)
		
		log(metaInfo: metaInfo, logRecord: logRecord)
	}
}
