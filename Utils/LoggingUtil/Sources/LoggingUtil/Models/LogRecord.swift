public struct LogRecord <Message: Codable, Details: LogRecordDetails>: Codable {
	public let metaInfo: MetaInfo
	public let message: Message
	public let details: Details?
	
	public func replace (_ metaInfo: MetaInfo, _ details: Details?) -> Self {
		.init(metaInfo: metaInfo, message: message, details: details)
	}
}
