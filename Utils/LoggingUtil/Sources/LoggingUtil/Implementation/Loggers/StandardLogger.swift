import Foundation

public struct StandardLogger <LogHandlerType: LogHandler> {
	public typealias Message = LogHandlerType.Message
	public typealias Details = LogHandlerType.Details
	
	public var isEnabled = true
	public var level = LogLevel.trace
	public var details: Details? = nil
	public var logHandler: LogHandlerType
	public let label: String
	
	public init (logHandler: LogHandlerType, label: String = "\(Self.self):\(#file):\(#line)") {
		self.logHandler = logHandler
		self.label = label
	}
}

extension StandardLogger: Logger {
	public func log (level: LogLevel, message: Message, details: Details? = nil) {
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

extension StandardLogger {
	public func isEnabled (_ isEnabled: Bool) -> Self {
		var selfCopy = self
		selfCopy.isEnabled = isEnabled
		return selfCopy
	}
	
	public func level (_ level: LogLevel) -> Self {
		var selfCopy = self
		selfCopy.level = level
		return selfCopy
	}
	
	public func details (_ details: Details) -> Self {
		var selfCopy = self
		selfCopy.details = details
		return selfCopy
	}
}
