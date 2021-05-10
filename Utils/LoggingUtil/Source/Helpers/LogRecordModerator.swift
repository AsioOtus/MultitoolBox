struct LogRecordModerator {
	static let `default` = Self()
	
	func moderate <Message> (logRecord: LogRecord<Message>, enabling: EnablingConfig) -> LogRecord<Message> {
		.init(
			timestamp: enabling.timestamp ? logRecord.timestamp : nil,
			level: enabling.level ? logRecord.level : nil,
			message: logRecord.message,
			source: enabling.source ? logRecord.source : nil
		)
	}
}
