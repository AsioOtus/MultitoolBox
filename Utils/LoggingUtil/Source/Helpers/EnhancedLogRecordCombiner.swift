struct EnhancedLogRecordCombiner {
	static let `default` = Self()
	
	func combine <Message> (_ logRecord: EnhancedLogRecord<Message>, _ loggerInfo: EnhancedLoggerInfo, _ sourcePrefix: String) -> EnhancedLogRecord<Message> {
		let source = logRecord.source ?? []
		let tags = logRecord.tags ?? []
		let details = logRecord.details ?? [:]
		let comment = logRecord.comment == nil ? nil : (logRecord.comment!.isEmpty == true ? nil : logRecord.comment)
		let labels = logRecord.labels ?? []
		
		let logRecord = EnhancedLogRecord(
			level: logRecord.level,
			message: logRecord.message,
			source: [sourcePrefix] + loggerInfo.source + source,
			tags: loggerInfo.tags.union(tags),
			details: loggerInfo.details.merging(details, uniquingKeysWith: { _, detail in detail }),
			comment: comment ?? loggerInfo.comment,
			labels: labels + [loggerInfo.label]
		)
		
		return logRecord
	}
}
