public protocol LogHandler {
	associatedtype Message: Codable
	
	func log (metaInfo: MetaInfo, logRecord: LogRecord<Message>)
}
