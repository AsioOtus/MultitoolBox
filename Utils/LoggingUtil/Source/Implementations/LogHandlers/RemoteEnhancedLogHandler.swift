import Foundation



public extension RemoteEnhancedLogHandler {
	struct Configuration {
		public var url: URL
		public var urlSession: URLSession
		public var enabling: EnhancedEnablingConfig
		
		public init (
			url: URL,
			urlSession: URLSession = .shared,
			enabling: EnhancedEnablingConfig = .init()
		) {
			self.url = url
			self.urlSession = urlSession
			self.enabling = enabling
		}
	}
}





public class RemoteEnhancedLogHandler {
	public typealias Message = String
	
	public var configuration: Configuration
	public var loggerInfo: EnhancedLoggerInfo
	
	public init (
		configuration: Configuration,
		loggerInfo: EnhancedLoggerInfo = .init()
	) {
		self.configuration = configuration
		self.loggerInfo = loggerInfo
	}
	
	private func log (_ logRecord: EnhancedLogRecord<Message>, _ configuration: Configuration?) {
		do {
			let configuration = configuration ?? self.configuration
			
			var urlRequest = URLRequest(url: configuration.url)
			urlRequest.httpMethod = "POST"
			urlRequest.httpBody = try JSONEncoder().encode(logRecord)
			
			configuration.urlSession.dataTask(with: urlRequest) { (data, urlResponse, error) in
				if let error = error {
					print(error.localizedDescription)
				}
			}.resume()
		} catch {
			print(error.localizedDescription)
		}
	}
}





extension RemoteEnhancedLogHandler: EnhancedLogHandler {
	public func log (level: LoggingLevel, logRecord: LogRecord<String>) {
		guard level >= loggerInfo.level else { return }
		
		let source = logRecord.source ?? []
		
		let logRecord = EnhancedLogRecord(
			level: logRecord.level,
			message: logRecord.message,
			source: source,
			tags: loggerInfo.tags,
			details: loggerInfo.details,
			comment: loggerInfo.comment,
			labels: [loggerInfo.label]
		)
		
		let moderatedLogRecord = EnhancedModerator.default.moderate(
			logRecord: logRecord,
			enabling: configuration.enabling
		)
		
		log(moderatedLogRecord, configuration)
	}
	
	public func log (level: LoggingLevel, logRecord: EnhancedLogRecord<String>, configuration: Configuration?) {
		guard level >= loggerInfo.level else { return }
		
		let configuration = configuration ?? self.configuration
		
		let logRecord = EnhancedLogRecordCombiner.default.combine(logRecord, loggerInfo, "")
		
		let moderatedLogRecord = EnhancedModerator.default.moderate(
			logRecord: logRecord,
			enabling: configuration.enabling
		)
		
		log(moderatedLogRecord, configuration)
	}
}
