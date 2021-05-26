public struct TransparentStringLogExporterAdapter <LogExporterType: LogExporter>: StringLogExporterAdapter where LogExporterType.Message == LogRecord<String, StandardLogRecordDetails> {
	public var logExporter: LogExporterType
	
	public init (_ logExporter: LogExporterType) {
		self.logExporter = logExporter
	}
	
	public func adapt (logRecord: LogRecord<String, StandardLogRecordDetails>) {
		logExporter.log(metaInfo: logRecord.metaInfo, message: logRecord)
	}
}
