public class StandardEnhancedLogHandler<LogExporter: StringLogExporter> {
	public typealias Message = String
	
	public var loggerInfo: EnhancedLoggerInfo
	public var enabling: EnhancedEnablingConfig
	public var logRecordFormatter: StringLogRecordFormatted
	public var logExporter: LogExporter
	
	public init (
		loggerInfo: EnhancedLoggerInfo = .init(),
		enabling: EnhancedEnablingConfig = .init(),
		logRecordFormatter: StringLogRecordFormatted,
		logExporter: LogExporter
	) {
		self.loggerInfo = loggerInfo
		self.enabling = enabling
		self.logRecordFormatter = logRecordFormatter
		self.logExporter = logExporter
	}
}


extension StandardEnhancedLogHandler: EnhancedLogHandler {
	public func log (metaInfo: MetaInfo, logRecord: LogRecord<Message>) {
		let metaInfo = EnhancedMetaInfo(timestamp: metaInfo.timestamp, level: metaInfo.level, labels: [])
		
		let logRecord = EnhancedLogRecord(
			level: logRecord.level,
			message: logRecord.message,
			source: logRecord.source
		)
		
		log(metaInfo: metaInfo, logRecord: logRecord)
	}
	
	public func log (metaInfo: EnhancedMetaInfo, logRecord: EnhancedLogRecord<Message>) {
		guard metaInfo.level >= loggerInfo.level else { return }
		
		let metaInfo = EnhancedMetaInfo(timestamp: metaInfo.timestamp, level: metaInfo.level, labels: [loggerInfo.label] + metaInfo.labels)
		let logRecord = EnhancedLogRecordCombiner.default.combine(logRecord, loggerInfo)
		
		let moderatedLogRecord = EnhancedModerator.default.moderate(logRecord: logRecord, enabling: enabling)
		let finalMessage = logRecordFormatter.format(logRecord: moderatedLogRecord)
		
		logExporter.log(metaInfo.level, finalMessage, nil)
	}
}
