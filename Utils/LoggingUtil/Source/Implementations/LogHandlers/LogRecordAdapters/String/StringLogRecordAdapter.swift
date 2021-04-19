public protocol StringLogRecordAdapter {
	func adapt (metaInfo: EnhancedMetaInfo, logRecord: EnhancedLogRecord<String>)
}

