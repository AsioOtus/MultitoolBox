public protocol EnhancedLogHandler: LogHandler {	
	func log (
		metaInfo: EnhancedMetaInfo,
		logRecord: EnhancedLogRecord<Message>
	)
}
