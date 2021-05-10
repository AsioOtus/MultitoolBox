struct LogRecordCombiner {
	static let `default` = Self()
	
	func combine <Message> (_ logRecord: LogRecord<Message>, _ loggerInfo: LoggerInfo) -> LogRecord<Message> {
		let comment = logRecord.comment == nil || logRecord.comment?.isEmpty == true
			? nil
			: logRecord.comment
		
		let logRecord = LogRecord(
			timestamp: logRecord.timestamp,
			level: logRecord.level,
			message: logRecord.message,
			source: loggerInfo.source + (logRecord.source ?? [])
		)
		
		return logRecord
	}
}
