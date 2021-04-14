import Foundation

public extension RemoteEnhancedLogHandler {
	struct TransportModel: Codable {
		public let metaInfo: EnhancedMetaInfo
		public let logRecord: EnhancedLogRecord<Message>
	}
}

public class RemoteEnhancedLogHandler {
	public typealias Message = String
	
	public var url: URL
	public var urlSession: URLSession
	public var loggerInfo: EnhancedLoggerInfo
	public var enabling: EnhancedEnablingConfig
	
	public init (
		url: URL,
		urlSession: URLSession = .shared,
		loggerInfo: EnhancedLoggerInfo = .init(),
		enabling: EnhancedEnablingConfig = .init()
	) {
		self.url = url
		self.urlSession = urlSession
		self.loggerInfo = loggerInfo
		self.enabling = enabling
	}
	
	private func log (_ metaInfo: EnhancedMetaInfo, _ logRecord: EnhancedLogRecord<Message>) {
		do {
			let transportModel = TransportModel(metaInfo: metaInfo, logRecord: logRecord)
			
			var urlRequest = URLRequest(url: url)
			urlRequest.httpMethod = "POST"
			urlRequest.httpBody = try JSONEncoder().encode(transportModel)
			
			urlSession.dataTask(with: urlRequest) { (data, urlResponse, error) in
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
	public func log (metaInfo: MetaInfo, logRecord: LogRecord<String>) {
		let logRecord = EnhancedLogRecord(
			level: logRecord.level,
			message: logRecord.message,
			source: logRecord.source
		)
		
		log(metaInfo: .init(timestamp: metaInfo.timestamp, level: metaInfo.level, labels: []), logRecord: logRecord)
	}
	
	public func log (metaInfo: EnhancedMetaInfo, logRecord: EnhancedLogRecord<String>) {
		guard metaInfo.level >= loggerInfo.level else { return }
				
		let logRecord = EnhancedLogRecordCombiner.default.combine(logRecord, loggerInfo)
		
		let moderatedLogRecord = EnhancedModerator.default.moderate(
			logRecord: logRecord,
			enabling: enabling
		)
		
		log(metaInfo, moderatedLogRecord)
	}
}
