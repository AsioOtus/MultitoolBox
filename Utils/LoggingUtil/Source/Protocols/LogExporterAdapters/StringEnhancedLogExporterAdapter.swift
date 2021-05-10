public protocol StringEnhancedLogExporterAdapter: StringLogExporterAdapter {
	func adapt (metaInfo: EnhancedMetaInfo, logRecord: EnhancedLogRecord<String>)
}

public extension StringEnhancedLogExporterAdapter {
	func adapt (metaInfo: MetaInfo, logRecord: EnhancedLogRecord<String>) {
		let metaInfo = EnhancedMetaInfo(timestamp: metaInfo.timestamp, level: metaInfo.level, labels: [])
		
		let logRecord = EnhancedLogRecord(
			level: logRecord.level,
			message: logRecord.message,
			source: logRecord.source
		)
		
		adapt(metaInfo: metaInfo, logRecord: logRecord)
	}
}
