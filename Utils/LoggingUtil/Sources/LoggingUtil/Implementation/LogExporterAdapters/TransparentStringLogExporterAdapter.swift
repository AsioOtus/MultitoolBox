public struct TransparentStringLogExporterAdapter <LogExporterType: LogExporter>: StringLogExporterAdapter where LogExporterType.Message == LogRecord<String, StandardLogRecordDetails> {
	public var logExporter: LogExporterType
	
	public func adapt (logRecord: LogRecord<String, StandardLogRecordDetails>) {
		logExporter.log(metaInfo: logRecord.metaInfo, message: logRecord)
	}
}
