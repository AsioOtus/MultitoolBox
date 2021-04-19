public struct TransparentLogRecordAdapter <LogExporterType: LogExporter>: StringLogRecordAdapter where LogExporterType.Message == EnhancedLogRecord<String> {
	public var logExporter: LogExporterType
	
	public func adapt (metaInfo: EnhancedMetaInfo, logRecord: EnhancedLogRecord<String>) {
		logExporter.log(metaInfo: metaInfo, message: logRecord, configuration: nil)
	}
}