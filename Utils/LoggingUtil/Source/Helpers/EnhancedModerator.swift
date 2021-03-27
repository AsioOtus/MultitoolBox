struct EnhancedModerator {
	static let `default` = Self()
	
	func moderate <Message> (logRecord: EnhancedLogRecord<Message>, enabling: EnhancedEnablingConfig) -> EnhancedLogRecord<Message> {
		.init(
			level: enabling.level ? logRecord.level : nil,
			message: logRecord.message,
			source: enabling.source ? logRecord.source : nil,
			tags: enabling.tags ? logRecord.tags : nil,
			details: enabling.details ? logRecord.details : nil,
			comment: enabling.comment ? logRecord.comment : nil,
			file: enabling.codeInfo ? logRecord.file : nil,
			function: enabling.codeInfo ? logRecord.function : nil,
			line: enabling.codeInfo ? logRecord.line : nil
		)
	}
}
