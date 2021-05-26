import Foundation

public struct StandardLogger <LogHandlerType: LogHandler> {
	public typealias Message = LogHandlerType.Message
	public typealias Details = LogHandlerType.Details
	
	public var isEnabled: Bool
	public var level: LogLevel
	public var logHandler: LogHandlerType
	public var details: Details?
	public let label: String
	
	public init (
		isEnabled: Bool = true,
		level: LogLevel = .trace,
		logHandler: LogHandlerType,
		details: Details? = nil,
		label: String = "\(Self.self):\(#file):\(#line)"
	) {
		self.isEnabled = isEnabled
		self.level = level
		self.logHandler = logHandler
		self.details = details
		self.label = label
	}
}



extension StandardLogger: Logger {
	public func log (level: LogLevel, message: Message, details: Details?) {
		let metaInfo = MetaInfo(timestamp: Date().timeIntervalSince1970, level: level, labels: [])
		let logRecord = LogRecord(metaInfo: metaInfo, message: message, details: details)
		
		log(logRecord: logRecord)
	}
}

extension StandardLogger: LogHandler {
	public func log (logRecord: LogRecord<Message, Details>) {
		guard isEnabled, logRecord.metaInfo.level >= level else { return }
		
		let metaInfo = logRecord.metaInfo.add(label: label)
		let details = logRecord.details?.combined(with: self.details)
		let logRecord = logRecord.replace(metaInfo, details)
		
		logHandler.log(logRecord: logRecord)
	}
}
