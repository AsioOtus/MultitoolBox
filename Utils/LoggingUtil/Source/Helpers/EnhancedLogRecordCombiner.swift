struct EnhancedLogRecordCombiner {
	static let `default` = Self()
	
	func combine <Message> (_ logRecord: EnhancedLogRecord<Message>, _ loggerInfo: EnhancedLoggerInfo) -> EnhancedLogRecord<Message> {
		let comment = logRecord.comment == nil
			? nil
			: (
				logRecord.comment!.isEmpty == true
					? nil
					: logRecord.comment
			)
		
		let logRecord = EnhancedLogRecord(
			level: logRecord.level,
			message: logRecord.message,
			source: loggerInfo.source + (logRecord.source ?? []),
			tags: loggerInfo.tags.union(logRecord.tags ?? []),
			details: loggerInfo.details.merging(logRecord.details ?? [:], uniquingKeysWith: { _, detail in detail }),
			comment: comment ?? loggerInfo.comment,
			labels: [loggerInfo.label] + (logRecord.labels ?? [])
		)
		
		return logRecord
	}
}
