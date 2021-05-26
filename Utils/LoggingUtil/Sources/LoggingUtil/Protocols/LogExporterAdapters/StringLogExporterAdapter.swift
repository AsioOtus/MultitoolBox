public protocol StringLogExporterAdapter {
	func adapt (logRecord: LogRecord<String, StandardLogRecordDetails>)
}
