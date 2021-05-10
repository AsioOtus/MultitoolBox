public protocol StringLogExporterAdapter {
	func adapt (metaInfo: MetaInfo, logRecord: EnhancedLogRecord<String>)
}
