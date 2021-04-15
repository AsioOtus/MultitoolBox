public protocol StringLogRecordFormatted {
	func format (logRecord: EnhancedLogRecord<String>) -> String
}
