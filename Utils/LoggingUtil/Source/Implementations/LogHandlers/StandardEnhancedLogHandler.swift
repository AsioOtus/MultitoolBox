public extension StandardEnhancedLogHandler {
	struct Configuration {
		public var sourcePrefix: String
		public var logRecordFormatter: StringLogRecordFormatted
		public var enabling: EnhancedEnablingConfig
		public var logExporterConfiguration: LogExporter.Configuration?
		
		public init (
			sourcePrefix: String = "",
			logRecordFormatter: StringLogRecordFormatted,
			enabling: EnhancedEnablingConfig = .init(),
			logExporterConfiguration: LogExporter.Configuration? = nil
		) {
			self.sourcePrefix = sourcePrefix
			self.logRecordFormatter = logRecordFormatter
			self.enabling = enabling
			self.logExporterConfiguration = logExporterConfiguration
		}
	}
}



public class StandardEnhancedLogHandler<LogExporter: StringLogExporter> {
	public typealias Message = String
	
	public var configuration: Configuration
	public var loggerInfo: EnhancedLoggerInfo
	public var stringLogExporter: LogExporter
	
	public init (
		configuration: Configuration,
		loggerInfo: EnhancedLoggerInfo = .init(),
		stringLogExporter: LogExporter
	) {
		self.configuration = configuration
		self.loggerInfo = loggerInfo
		self.stringLogExporter = stringLogExporter
	}
}


extension StandardEnhancedLogHandler: EnhancedLogHandler {
	public func log (level: LoggingLevel, logRecord: LogRecord<String>) {		
		let logRecord = EnhancedLogRecord(
			level: logRecord.level,
			message: logRecord.message,
			source: logRecord.source
		)
		
		log(level: level, logRecord: logRecord, configuration: nil)
	}
	
	public func log (level: LoggingLevel, logRecord: EnhancedLogRecord<String>, configuration: Configuration?) {
		guard level >= loggerInfo.level else { return }
		
		let configuration = configuration ?? self.configuration
		let logRecord = EnhancedLogRecordCombiner.default.combine(logRecord, loggerInfo, configuration.sourcePrefix)
		let moderatedLogRecord = EnhancedModerator.default.moderate(
			logRecord: logRecord,
			enabling: configuration.enabling
		)
		
		let finalMessage = configuration.logRecordFormatter.format(logRecord: moderatedLogRecord)
		stringLogExporter.log(level, finalMessage, configuration.logExporterConfiguration)
	}
}
